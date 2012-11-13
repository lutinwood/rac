require 'redmine'
require 'dispatcher' unless Rails::VERSION::MAJOR >= 3

if Rails::VERSION::MAJOR >=3 
    ActionDispatch::Callbacks.to_prepare do
      #use require_dependency if you plan to utilize development mode
      require 'user_patch'
    end
  else
    Dispatcher.to_prepare :rac do
      #use require_dependency if you plan to utilize development mode
      require_dependency 'cas'
      require 'user_patch'
      require 'account_controller_patch'
      require 'my_controller_patch'
    end
end




Dispatcher.to_prepare :rac do
 
  User.send(:include, UserPatch)
  AccountController.send(:include, AccountControllerPatch)
  MyController.send(:include, MyControllerPatch)

end

Redmine::Plugin.register :rac do
  name 'Redmine Aua Cas'
  author 'Thierry Forest, UNiversité Angers Antoine Mahul, Universite Blaise Pascal'
  description 'Adding SSO'
  version 'v-0.6 -- 0.2.0'
 
  settings :default => {'help_url' => Redmine::Info.help_url}, :partial => 'settings/rac_settings'
  delete_menu_item :account_menu, :register
  delete_menu_item :top_menu, :help 
  menu :top_menu, :faq, {:controller=>'help', :action=>'index'}, :last => true 
  # ajouter aide dans le menu supérieur 
  
  requires_redmine :version_or_higher => '1.4.4'
  
  
end