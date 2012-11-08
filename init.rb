require 'redmine'
require 'dispatcher'

require_dependency 'cas'

require 'user_patch'
require 'account_controller_patch'

require 'my_controller_patch'


Dispatcher.to_prepare :rac do
  Principal.send(:include, PrincipalPatch)
  User.send(:include, UserPatch)
  AnonymousUser.send(:include, AnonymousUserPatch)
  AccountController.send(:include, AccountControllerPatch)

  MyController.send(:include, MyControllerPatch)

end

Redmine::Plugin.register :rac do
  name 'Forge Clermont Universite plugin'
  author 'Antoine Mahul, Universite Blaise Pascal'
  description 'Adding Clermont Universite SSO Authentication and others little things'
  version 'v-0.5 -- 0.2.0'
  

  settings :default => {'help_url' => Redmine::Info.help_url}, :partial => 'settings/rac_settings'
  delete_menu_item :account_menu, :register
  delete_menu_item :top_menu, :help 
  menu :top_menu, :faq, {:controller=>'help', :action=>'index'}, :last => true 
  
  requires_redmine :version_or_higher => '1.4.4'
  permission :add_member_from_ldap, :ldapsearch => [:index,:search,:add], :require => :member
  
end


