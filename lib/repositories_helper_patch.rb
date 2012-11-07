module RepositoriesHelperPatch

  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)

    base.class_eval do
      unloadable
    end
  end
  
  module InstanceMethods

    def repository_info_hash(repository)
       case repository.scm_name
         when "Git"
           urlpub = git_url(repository.project)
           urlpriv = git_url(repository.project,"<em>login</em>")
           infos = { :dev_cmdline => "  git remote add forge #{urlpriv} \n  git push forge master", 
                     :public_cmdline => "  git clone #{urlpub}", 
                     :protocol => "SmartHTTP"}
         when "Subversion"
           url = svn_url(repository.project)
           infos = { :dev_cmdline => "  svn --username <em>login</em> import #{url}", 
                     :public_cmdline => "  svn checkout #{url}", 
                     :protocol => "DAV"}
       end
       return infos
    end

    def svn_url(project)
      return File.join(Setting.plugin_redmine_clruniv['svn_url'],project.identifier)
    end


    def git_url(project,user=nil)
       if(not user.nil? and Setting.plugin_redmine_clruniv['git_url'] =~  /(\w+:\/+)(.*)/)
         return File.join("#{$1}#{user}@#{$2}",project.identifier)
       end
       return File.join(Setting.plugin_redmine_clruniv['git_url'],project.identifier)
    end

    def show_repository_url(repository)
       case repository.scm_name
         when "Git"; return git_url(repository.project)
         when "Subversion"; return svn_url(repository.project)
       end
    end

    def show_repository_infos(repository)
      scm_name = repository.scm_name
      infos = repository_info_hash(repository)
      s = ''
      s << "<p>#{l(:clruniv_repository_created, scm_name)}</p>"
      s << "<p>#{l(:clruniv_repository_dev_access, infos[:protocol])} :"
      s << "<pre align=\"center\">#{infos[:dev_cmdline]}</pre>"
      s << "</p>"
      if repository.project.is_public?
        s << "<p>#{l(:clruniv_repository_anon_access)} :"
        s << "<pre align=\"center\">#{infos[:public_cmdline]}</pre>"
        s << "</p>"
      end
      return s
    end
   
  end

end
