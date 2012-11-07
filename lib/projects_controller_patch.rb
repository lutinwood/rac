module ProjectsControllerPatch

  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)

    base.class_eval do
      unloadable
      before_filter :repo_warn, :only => :settings
    end
  end
  
  module InstanceMethods
    private
    def repo_warn
      if @project.module_enabled?(:repository) && !@project.repository && !ReposmanRequest.pending.creation.find(:all, :conditions => { :project_id => @project}).any?
        flash.now[:warning] =l(:clruniv_warn_config_repo)
      end
    end

  end

end
