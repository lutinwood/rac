require 'redmine'
require 'dispatcher'

require_dependency 'cas'

require 'user_patch'
require 'account_controller_patch'
require 'my_controller_patch'

Dispatcher.to_prepare :redmine_clruniv do
  Principal.send(:include, PrincipalPatch)
  User.send(:include, UserPatch)
  AnonymousUser.send(:include, AnonymousUserPatch)
  AccountController.send(:include, AccountControllerPatch)
  MyController.send(:include, MyControllerPatch)
end

Redmine::Plugin.register :redmine_clruniv do
  name 'Forge Clermont Universite plugin'
  author 'ORIGINAL /Antoine Mahul, Universite Blaise Pascal/ Modifié par Thierry Forest, université d Angers'
  description 'Authentification pas CAS '
  version '0.2.3'
  
  settings :default => {'help_url' => Redmine::Info.help_url}, :partial => 'settings/clruniv_settings'
  delete_menu_item :account_menu, :register
  delete_menu_item :top_menu, :help 
  menu :top_menu, :help, {:controller=>'help', :action=>'index'}, :last => true 
  requires_redmine :version_or_higher => '1.3.0'
  permission :add_member_from_ldap, :ldapsearch => [:index,:search,:add], :require => :member
end


