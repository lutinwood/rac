class FormationsController < ApplicationController
    unloadable
    
    def index
      @formations = Formation.all
	respond_to do |format|
	format.html
	end 

    end
    
    def new
      @formation = Formation.all
	respond_to do |format|
	format.html# {redirect_to '/settings/plugin/rac'}
	end
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
 

# PUT /formation/1  
    def update 
        @formations = Formation.find(params[:id])
          #Nouvelle entrée
            if params[:state].eql? "new"
                @formation = Formation.new
            end
            respond_to do |format|
                format.html # full_update.html.erb
            end
    end
    
    # PUT /formation/1
  

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
