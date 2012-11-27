class FormationsController < ApplicationController
    unloadable
    
    def index
      @formations = Formation.all
    end
    
    def new
      @formation = Formation.all
    end
    
    def create
      @formation = Formation.new(params[:formation])
    end
    
    def update 
     #  @formation = Formation.find(params[:id])
      @formations = Formation.all
	respond_to do |format|
		format.html { render :action => :new }
	end
    end
    
    def destroy 
        @formation = Formation.find(params[:id])
      
    end
end
