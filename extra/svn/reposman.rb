#!/usr/bin/env ruby

# == Synopsis
#
# reposman: manages your repositories with Redmine
#
# == Usage
#
#    reposman [OPTIONS...] -s [DIR] -r [HOST]
#     
#  Examples:
#    reposman --svn-dir=/var/svn --redmine-host=redmine.example.net --scm subversion
#    reposman -s /var/git -r redmine.example.net -u http://svn.example.net --scm git
#
# == Arguments (mandatory)
#
#   -r, --redmine-host=HOST   assume Redmine is hosted on HOST. Examples:
#                             -r redmine.example.net
#                             -r http://redmine.example.net
#                             -r https://example.net/redmine
#   -k, --key=KEY             use KEY as the Redmine API key
#
# == Options
#   -f, --force               force repository creation even if the project
#                             repository is already declared in Redmine
#   -t, --test                only show what should be done
#   -h, --help                show help and exit
#   -v, --verbose             verbose
#   -V, --version             print version and exit
#   -q, --quiet               no log
#
# == References
# 
# You can find more information on the redmine's wiki : http://www.redmine.org/wiki/redmine/HowTos


require 'getoptlong'
require 'rdoc/usage'
require 'find'
require 'etc'
require 'active_resource'

Version = "1.3"
SUPPORTED_SCM = %w( Subversion Darcs Mercurial Bazaar Git Filesystem )

opts = GetoptLong.new(
                      ['--redmine-host', '-r', GetoptLong::REQUIRED_ARGUMENT],
                      ['--key',          '-k', GetoptLong::REQUIRED_ARGUMENT],
                      ['--test',         '-t', GetoptLong::NO_ARGUMENT],
                      ['--force',        '-f', GetoptLong::NO_ARGUMENT],
                      ['--verbose',      '-v', GetoptLong::NO_ARGUMENT],
                      ['--version',      '-V', GetoptLong::NO_ARGUMENT],
                      ['--help'   ,      '-h', GetoptLong::NO_ARGUMENT],
                      ['--quiet'  ,      '-q', GetoptLong::NO_ARGUMENT]
                      )

$verbose      = 0
$quiet        = false
$redmine_host = ''
$test         = false
$force        = false

# ======================================================================================================================
def log(text, options={})
  level = options[:level] || 0
  puts text unless $quiet or level > $verbose
  exit 1 if options[:exit]
end

def system_or_raise(command)
  raise "\"#{command}\" failed" unless system command
end

def mswin?
  (RUBY_PLATFORM =~ /(:?mswin|mingw)/) || (RUBY_PLATFORM == 'java' && (ENV['OS'] || ENV['os']) =~ /windows/i)
end


# ======================================================================================================================
module SCMConfig

  Subversion = {
    :url => "file:///srv/svn",
    :basedir => "/srv/svn",
    :owner => "www-data",
    :group => "redmine",
    :mode => "o-rwx"
  }

  Git = {
    :url => "/srv/git",
    :basedir => "/srv/git",
    :owner => "git",
    :group => "redmine",
  }
end

# ======================================================================================================================
class SCM

  @@scm = {}
  attr_reader :basedir, :owner, :group, :url, :mode

  # --------------------------------------------------------------------------------------------------------------------
  def self.factory(scmid)
    @@scm[scmid] = SCM.const_get(scmid).new(SCMConfig.const_get(scmid)) unless @@scm.has_key?(scmid)
    return @@scm[scmid]
  end

  # --------------------------------------------------------------------------------------------------------------------
  def initialize(opts)
    opts.each do |opt, arg|
      case opt
      when :basedir; @basedir  = arg.dup;
      when :owner;   @owner    = arg.dup;
      when :group;   @group    = arg.dup;
      when :url;     @url      = arg.dup;
      when :mode;    @mode     = arg;
      end
    end
    @url += "/" if @url and not @url.match(/\/$/)
    unless File.directory?(@basedir)
      log("directory '#{@basedir}' doesn't exists", :exit => true)
    end
  end

  # --------------------------------------------------------------------------------------------------------------------
  def set_owner_and_rights(project, repos_path, &block)
    if RUBY_PLATFORM =~ /mswin/
      yield if block_given?
    else
      uid, gid = Etc.getpwnam(@owner).uid, 
                 (@group.nil? ?  Etc.getgrnam(project.identifier).gid : Etc.getgrnam(@group).gid)
      yield if block_given?
      Find.find(repos_path) do |f|
        File.chmod mode, f
        File.chown uid, gid, f
      end
    end
  end

  # --------------------------------------------------------------------------------------------------------------------
  def owner_name(file)
    mswin? ?
      @owner :
      Etc.getpwuid( File.stat(file).uid ).name  
  end

  # --------------------------------------------------------------------------------------------------------------------
  def other_read_right?(file)
    (File.stat(file).mode & 0007).zero? ? false : true
  end

  # --------------------------------------------------------------------------------------------------------------------
  def create(path)
    raise NotImplementedError.new("You must implement #{self.class}.create.")
  end

end

# ======================================================================================================================
class Subversion < SCM
  def create(path)
    system_or_raise "svnadmin create #{path}"
    system_or_raise "chown -R #{@owner}:#{@group} #{path}"
    system_or_raise "chmod -R #{@mode} #{path}"
  end
end

# ======================================================================================================================
class Git < SCM
  def create(path)
    Dir.mkdir path
    Dir.chdir(path) do
      system_or_raise "git --bare init" # --shared
      system_or_raise "git update-server-info"
    end
    system_or_raise "chown -R #{@owner}:#{@group} #{path}"
  end
end

# ======================================================================================================================
class RedmineResource < ActiveResource::Base
  cattr_accessor :api_key
  @@api_key = nil
end

# ======================================================================================================================
class ReposmanRequest < RedmineResource
  
  # --------------------------------------------------------------------------------------------------------------------
  def self.find_pending
    begin
      # Get all active projects that have the Repository module enabled
      requests = self.find(:all, :params => {:key => @@api_key})
    rescue => e
      log("Unable to connect to #{Project.site}: #{e}", :exit => true)
    end
    
    if requests.nil?
      log('no request found, perhaps you forgot to "Enable WS for repository management"', :exit => true)
    end

    
    log("retrieved #{requests.size} requests", :level => 1)
    return requests
  end

  # --------------------------------------------------------------------------------------------------------------------
  def done(comments = nil, options = {})
    log("\t#{comments}", options) unless comments.nil?
    begin
      self.post(:close, :comments => "#{comments}", :key => @@api_key)
      log("\trequest #{id} was successfully closed");
    rescue => e
      log("\trequest #{id} can't be closed : #{e.message}");
    end
  end

  

  # --------------------------------------------------------------------------------------------------------------------
  def create
    project = self.project

    if project.respond_to?(:repository)
      self.done("repository for project #{project.identifier} already exists in Redmine",:level => 1)
      return
    end

    begin
      scm = SCM.factory(self.options)
    rescue
      self.done("invalid SCM #{self.options} in request #{request.id} for project #{request.project.identifier}")
      return
    end

    path = File.join(scm.basedir, project.identifier).gsub(File::SEPARATOR, File::ALT_SEPARATOR || File::SEPARATOR)
    if File.directory?(path)
      self.done("directory #{path} for project #{project.identifier} already exists")
      return
    end

   # project.is_public ? File.umask(0002) : File.umask(0007)

    if $test
      log("\tcreate repository #{path}")
      log("\trepository #{path} registered in Redmine with url #{scm.url}#{project.identifier}") if scm.url;
      return
    end

    begin
      scm.create(path)
    rescue => e
      self.done("unable to create #{path} : #{e}\n")
      return
    end

    log("\trepository #{path} created");

    if scm.url
      begin
        project.post(:repository, 
                     :vendor => "#{scm.class}", 
                     :repository => {:url => "#{scm.url}#{project.identifier}"}, 
                     :key => @@api_key)

        log("\trepository #{path} registered in Redmine with url #{scm.url}#{project.identifier}");
        self.done()
      rescue => e
        self.done("repository #{path} not registered in Redmine: #{e.message}");
      end
    end

  end

protected

  # --------------------------------------------------------------------------------------------------------------------
  def validate
    return self.project.valid?
  end

end

# ======================================================================================================================
class Project < RedmineResource

  # --------------------------------------------------------------------------------------------------------------------
  def self.find_active
    begin
      # Get all active projects that have the Repository module enabled
      projects = self.find(:all, :params => {:key => @@api_key})
    rescue => e
      log("Unable to connect to #{Project.site}: #{e}", :exit => true)
    end
    
    if projects.nil?
      log('no project found, perhaps you forgot to "Enable WS for repository management"', :exit => true)
    end
    
    log("retrieved #{projects.size} projects", :level => 1)
    return projects
  end

protected

  # --------------------------------------------------------------------------------------------------------------------
  def validate
    if project.identifier.empty?
      log("\tno identifier for project #{project.name}")
      return false
    elsif not project.identifier.match(/^[a-z0-9\-]+$/)
      log("\tinvalid identifier for project #{project.name} : #{project.identifier}");
      return false
    end
    return true
  end

end

# =====================================================================================================================

begin
  opts.each do |opt, arg|
    case opt
    when '--redmine-host';   $redmine_host = arg.dup
    when '--key';            $api_key      = arg.dup
    when '--verbose';        $verbose += 1
    when '--test';           $test = true
    when '--force';          $force = true
    when '--version';        puts Version; exit
    when '--help';           RDoc::usage
    when '--quiet';          $quiet = true
    end
  end
rescue
  exit 1
end

if $test
  log("running in test mode")
end

if ($redmine_host.empty?)
  RDoc::usage
end


log("querying Redmine for projects...", :level => 1);

$redmine_host.gsub!(/^/, "http://") unless $redmine_host.match("^https?://")
$redmine_host.gsub!(/\/$/, '')

RedmineResource.site = "#{$redmine_host}/sys"
RedmineResource.api_key = $api_key


requests = ReposmanRequest.find_pending()

requests.each do |request|

  log("treating request '#{request.action}' (#{request.options}) for project #{request.project.name}", :level => 1)
  
  next if not request.valid?
  
  request.create() if request.action == "create"

#
#  if File.directory?(repos_path)
#
#    # we must verify that repository has the good owner and the good
#    # rights before leaving
#    other_read = other_read_right?(repos_path)
#    owner      = owner_name(repos_path)
#    next if project.is_public == other_read and owner == $svn_owner
#
#    if $test
#      log("\tchange mode on #{repos_path}")
#      next
#    end
#
#    begin
#      set_owner_and_rights(project, repos_path)
#    rescue Errno::EPERM => e
#      log("\tunable to change mode on #{repos_path} : #{e}\n")
#      next
#    end
#
#    log("\tmode change on #{repos_path}");
#
#  else
#    # if repository is already declared in redmine, we don't create
#    # unless user use -f with reposman
#    if $force == false and project.respond_to?(:repository)
#      log("\trepository for project #{project.identifier} already exists in Redmine", :level => 1)
#      next
#    end
#
#  end

end
  
#projects = Project.find_active()
#projects.each do |project|
#  log("treating project #{project.name}", :level => 1)
#  log(project.inspect)
#end
