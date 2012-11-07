class SsoController < ApplicationController
  unloadable
  # prevents login action to be filtered by check_if_login_required application scope filter
  skip_before_filter :check_if_login_required, :only => [:login]
  before_filter :find_cas, :only => [:login]

  before_filter :find_project, :only => [:ldapsearch_for_members]
  before_filter :authorize, :only => [:ldapsearch_for_members]

  # Log out current user and redirect to welcome page
  def logout
    logger.debug "from logout"
    cookies.delete :autologin
    Token.delete_all(["user_id = ? AND action = ?", User.current.id, 'autologin']) if User.current.logged?
    self.logged_user = nil
    
    if session[:sso_session]
      logger.debug session.inspect
      Cas.find_by_identifier(session[:sso_session]).logout(self)
    else
      reset_session
      redirect_to :controller => 'welcome'
    end
  end

  def login
    # Authenticate user
    if @cas.authenticate(self)  
      user = User.find_by_login(session[:cas_user])
      if user.nil? 
        logger.debug "user is new to the system "
        logger.debug user.inspect
        user = @cas.onthefly(session[:cas_user])
        logger.debug @cas.inspect
        logger.debug user.inspect
        if user.save
          self.logged_user = user
          flash[:notice] = l(:notice_account_activated)
          redirect_to :controller => "my", :action => "account"
        else
          
          flash[:error] = l(:notice_account_invalid_creditentials)
          redirect_to :controller => "account", :action => "register"
        end
      elsif (!user.cas or user.cas.url != @cas.url)  # On verifie que l'on provient toujours du meme CAS
        reset_session
       
        flash[:error] = l(:clruniv_userid_exists, user.login)
        redirect_to :controller => "account", :action => "register"
      else
        self.logged_user = user
        call_hook(:controller_account_success_authentication_after, {:user => user })
        if user.registered?  # On active le compte s'il n'est pas actif
          user.activate
          if user.save
            flash[:notice] = l(:notice_account_activated)
            redirect_back_or_default :controller => "my", :action => "account"
          else
            flash[:error] = l(:notice_account_invalid_creditentials)
            redirect_to :controller => "account", :action => "register"
          end
        else
          redirect_back_or_default :controller => 'my', :action => 'page'
        end
      end
    end
  end
  
private
  def logged_user=(user)
    if user && user.is_a?(User)
      User.current = user
      session[:user_id] = user.id
      session[:sso_session] = user.cas.identifier
    else
      User.current = User.anonymous
      session[:user_id] = nil
    end
  end

  def find_cas
    @cas = Cas.find_by_identifier(params[:cas_id])
    render_404 unless @cas
  end

end
