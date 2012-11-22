class FormationsController < ApplicationController
    unloadable
    
    def index
      @formations = Formation.all
    end
    
    def new
      @formation = Formation.new
    end
    
    def create
      @formation = Formation.new(params[:formation])
    end
    
    def update 
     #  @formation = Formation.find(params[:id])
      @formations = Formation.all
    end
    
    def destroy 
        @formation = Formation.find(params[:id])
      
    end
end
