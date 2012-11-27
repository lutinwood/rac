class FormationsController < ApplicationController
    unloadable
    
    def index
      @formations = Formation.all
    end
    
    def new
      @formation = Formation.all
    end
    
    #POST /formation
    def create
      @formation = Formation.new(params[:formation])
      respond_to do |format|
        if @formation.save
            format.html { redirect_to(:action => 'full_update')}
            
        end
      end
    end
    
    def full_update 
        @formations = Formation.all
          #Nouvelle entrée
            if params[:state].eql? "new"
                @formation = Formation.new
            end
            respond_to do |format|
                format.html # full_update.html.erb
            end
    end
    
    # PUT /formation/1
    def update 
     @formation = Formation.find(params[:id])
     	  respond_to do |format|
		      format.html { redirect_to(:action => 'full_update', :notice => 'Formation ws successfully updated. ') }
	      end
    end

	def update_formation
	 respond_to do |format|
		format.html { redirect_to('/settings/plugin/rac') }
		end
	end	
	

    
    def destroy 
        @formation = Formation.find(params[:id])
         @formation.destroy
          respond_to do |format|
              format.html { redirect_to(:action => 'full_update')}
            end
          end
      
    end