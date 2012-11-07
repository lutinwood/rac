module AccountControllerPatch

  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)

    base.class_eval do
      unloadable
      alias_method_chain :login, :cas
      alias_method_chain :lost_password, :cas
    end
  end
  
  module InstanceMethods
    # No login for 'CAS' account
    def login_with_cas
      return if request.get?
      user = User.find_by_login(params[:username])
      if !user.nil? and user.cas
        flash.now[:error] = l(:notice_account_invalid_creditentials)
      else
        login_without_cas
      end
    end

   # No way to change password for 'CAS' account
   def lost_password_with_cas
     if request.post?
       user = User.find_by_mail(params[:mail])
       flash.now[:error] = l(:notice_can_t_change_password) and return if (user and !user.change_password_allowed?)
       lost_password_without_cas
     end
   end

  end

end
