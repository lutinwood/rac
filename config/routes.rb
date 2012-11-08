ActionController::Routing::Routes.draw do |map|
 map.help 'help/index', :controller => 'help', :action => 'index', :conditions => {:method => :get}
 
  map.signout 'logout', :controller => "sso", :action => "logout"

#match 'sso/:cas_id'  => "sso#login":controller => "sso", :action => "login"

# cette ligne pose un robleme avec d'autres liens
#map.connect ':controller/:action/:back_url', :controller => "sso", :action => "login"

  map.connect 'sso/:cas_id', :controller => "sso", :action => "login", :cas_id => /.+/
  
  map.with_options :controller => 'ldapsearch' do |ldapsearch|
    ldapsearch.connect 'projects/:project_id/ldapsearch/add/:cas_id/:login', :action => 'addmember'
    ldapsearch.connect 'projects/:project_id/ldapsearch', :action => 'index'
  end

#map.connect 'auth_sources/:id/test_connection', :controller => 'auth_source', :action => 'test_connection'
end

