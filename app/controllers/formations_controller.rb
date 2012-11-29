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
	else
	format.html { redirect_to(:action => 'update')}
      end
    end
  end

  # PUT /formations/1
  def update
    # Nouvelle entrée 
    if params[:state].eql? "new"
      @formation = Formation.new
    end
   if !params[:id].nil?
      @formation = Formation.find(params[:id])
      @formation.update_attributes(params[:formation])
   end
    @formations = Formation.all
  
    respond_to do |format|
      format.html # update.html.erb
      end
    end
  end


  def destroy
    @formation = Formation.find(params[:id])
    @formation.destroy
    respond_to do |format|
      format.html { redirect_to(:action => 'update')} #update.html.erb
     
    end
  end

