ActionController::Routing::Routes.draw do |map|
 map.help 'help/index', :controller => 'help', :action => 'index', :conditions => {:method => :get}
 
  map.signout 'logout', :controller => "sso", :action => "logout"

  map.connect 'sso/:cas_id', :controller => "sso", :action => "login", :cas_id => /.+/
  

#map.connect 'auth_sources/:id/test_connection', :controller => 'auth_source', :action => 'test_connection'
end

