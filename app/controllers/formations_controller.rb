class FormationsController < ApplicationController
  unloadable
  #GET /formations
  def index
    @formations = Formation.all
    respond_to do |format|
      format.html #index.html.erb
    end
  end

  def new
    @formation = Formation.all
    respond_to do |format|
      format.html #new.html.erb
    end
  end

  #POST /formation
  def create
    @formation = Formation.new(params[:formation])
    respond_to do |format|
      if @formation.save
        format.html { redirect_to(:action => 'update')} #update.html.erb

      end
    end
  end

  # PUT /formations/1
  def update
    @formations = Formation.find(params[:id])
    #Nouvelle entrée
    if params[:state].eql? "new"
      @formation = Formation.new
    end
    respond_to do |format|
      
      format.html # update.html.erb
    end
  end


  def destroy
    @formation = Formation.find(params[:id])
    @formation.destroy
    respond_to do |format|
      format.html { redirect_to(:action => 'update')} #update.html.erb
     
    end
  end

end
