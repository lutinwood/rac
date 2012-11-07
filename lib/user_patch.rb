module PrincipalPatch
  def self.included(base) # :nodoc:
    base.class_eval do
      unloadable
    end
  end
end

module UserPatch

  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)
    base.class_eval do
      unloadable
      belongs_to :cas
      alias_method_chain :allowed_to?, :staff unless method_defined?(:allowed_to_without_staff?)
      alias_method_chain :change_password_allowed?, :cas unless method_defined?(:change_password_allowed_without_cas?)

      # Pour augmenter la taille max des emails, on supprime toutes les validations, et on les remet.
      @validate_callbacks = []
      validates_presence_of :login, :firstname, :lastname, :mail, :if => Proc.new { |user| !user.is_a?(AnonymousUser) }
      validates_uniqueness_of :login, :if => Proc.new { |user| !user.login.blank? }, :case_sensitive => false
      validates_uniqueness_of :mail, :if => Proc.new { |user| !user.mail.blank? }, :case_sensitive => false
      # Login must contain lettres, numbers, underscores only
      validates_format_of :login, :with => /^[a-z0-9_\-@\.]*$/i
      validates_length_of :login, :maximum => 30
      validates_format_of :firstname, :lastname, :with => /^[\w\s\'\-\.]*$/i
      validates_length_of :firstname, :lastname, :maximum => 30
      validates_format_of :mail, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :allow_nil => true
      validates_length_of :mail, :maximum => 255, :allow_nil => true
      validates_confirmation_of :password, :allow_nil => true
    end
  end
  
  module InstanceMethods

    def allowed_to_with_staff?(action, project, options={})
      logger.info "#### #{action.inspect}"
      if not self.admin?  # on ne change pas les droit d'admin
        if action == :add_project or (action.is_a?(Hash) and action[:controller] == 'projects' and (action[:action] == 'new' or action[:action] == 'create'))
          return true if self.staff?
        elsif action == :add_subprojects
          return false if not self.staff?
        elsif action.is_a?(Hash) and action[:controller] == 'ldapsearch'
          return false if not self.staff?
        end
      end
      allowed_to_without_staff?(action, project, options)
    end

    def staff?
      @staff = (!self.cas.nil? and self.cas.is_staff(self.login)) if @staff.nil?
      return @staff
    end
     
    def change_password_allowed_with_cas?
      return false if !self.cas.nil?
      return change_password_allowed_without_cas?
    end

  end

end

module AnonymousUserPatch

  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)
    base.class_eval do
      unloadable
    end
  end
  
  module InstanceMethods

    def staff?
      return false
    end

  end

end
