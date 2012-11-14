
# Désactiver  Par choix 

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
      
      alias_method_chain :change_password_allowed?, :cas unless method_defined?(:change_password_allowed_without_cas?)    
    end
  end
  
  module InstanceMethods

# old fonction  ==> allowed_to_with_staff?(action, project, options={})
# RETURN ==> boolean
# TRUE if 
#   action == ( :add_project or add_subprojects) and self.staff
#   or
#   action.is_a?(Hash) and action[:controller] == 'projects' and   and (action[:action] == 'new' or action[:action] == 'create')
#   and 
#   self.staff
#  else 
# FALSE
# will be replaced by a role 
    
    ## TOKEEP
    
    # If cas user do not allow to change the password 
    def change_password_allowed_with_cas?
      return false if !self.cas.nil?
      return change_password_allowed_without_cas?
    end

  end

end
