ActionController::Routing::Routes.draw do |map|

# custom route 
  map.help 'help/index', :controller => 'help', :action => 'index', :conditions => {:method => :get}
 
# Named route
  map.signout 'logout', :controller => "sso", :action => "logout"

# 
  map.connect 'sso/:cas_id', :controller => "sso", :action => "login", :cas_id => /.+/


#resources :formations

 map.connect 'settings/plugin/rac' , :controller => "formations", :action => "update"
# Route par default
#map.connect ':controller/:action/:id'

# with option 
#  map.with_option :controller => 'formations' do |formation|
#	formation.show		'',		:action => 'index'
#	formation.delete	'delete/:id',	:action => 'destroy'
#	formation.edit		'edit/:id',	:action => 'update'
#  end	

# 
#map.connect 'settings/plugin/:plugin', :controller => 'settings', :action => 'plugin', :conditions =>{ :method => [:post, :get]}  

end
  
