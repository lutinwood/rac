require 'redmine'
require 'dispatcher'

require_dependency 'cas'

require 'user_patch'
require 'account_controller_patch'
require 'sys_controller_patch'
require 'my_controller_patch'
require 'projects_controller_patch'
require 'repositories_helper_patch'

Dispatcher.to_prepare :redmine_clruniv do
  Principal.send(:include, PrincipalPatch)
  User.send(:include, UserPatch)
  AnonymousUser.send(:include, AnonymousUserPatch)
  AccountController.send(:include, AccountControllerPatch)
  SysController.send(:include, SysControllerPatch)
  MyController.send(:include, MyControllerPatch)
  RepositoriesHelper.send(:include, RepositoriesHelperPatch)
  ProjectsController.send(:include, ProjectsControllerPatch)
end

Redmine::Plugin.register :redmine_clruniv do
  name 'Forge Clermont Universite plugin'
  author 'Antoine Mahul, Universite Blaise Pascal'
  description 'Adding Clermont Universite SSO Authentication and others little things'
  version '0.2.0'
  
  settings :default => {'svn_url' => 'https://localhost/svn'}, :partial => 'settings/clruniv_settings'
  settings :default => {'git_url' => 'https://localhost/git'}, :partial => 'settings/clruniv_settings'
  settings :default => {'help_url' => Redmine::Info.help_url}, :partial => 'settings/clruniv_settings'
  delete_menu_item :account_menu, :register
  delete_menu_item :top_menu, :help 
  menu :top_menu, :faq, {:controller=>'help', :action=>'index'}, :last => true 
  
  requires_redmine :version_or_higher => '1.3.0'
  permission :add_member_from_ldap, :ldapsearch => [:index,:search,:add], :require => :member
  permission :repo_creation_request, :reposman => [:create], :require => :member
end


