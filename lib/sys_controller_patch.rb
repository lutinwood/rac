module SysControllerPatch

  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)

    base.class_eval do
      unloadable
    end
  end
  
  module InstanceMethods

    def requests
      requests = ReposmanRequest.pending.find(:all, :include => [:project])
      render :xml => requests.to_xml(:include => {:project => {:include => [:repository]}})
    end

    def close_request 
      r = ReposmanRequest.find(params[:id])
      r.done = true
      r.comments = params[:comments]
      logger.info "Request #{r.id} for #{r.project.name} was reported to be done #{request.remote_ip} : #{r.comments}"
      if r.save
        render :xml => r, :status => 201
      else
       render :nothing => true, :status => 422
     end
    end

  end

end
