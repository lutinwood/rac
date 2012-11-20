class CursusController < ApplicationController
  unloadable
  
  before_filter :load_cursus
  def index
    @Cursus = Cursus.all
    
    respond_to do | format|
      format.html # index.html.erb
      format.json { render :json => @Cursus}
    end
  end
   def new
      @cursus = Cursus.new
     
     respond_to do |format|
       format.html # index.html.erb
      format.json { render :json => @cursus}
     format.js {render :layout => false}
     end
  end
    def create 
    @cursus  = Cursus.new(params[:cursus])
    
    respond_to do |format|
      if @cursus.save
         format.html { redirect_to(@cursus, :notice => 'Cursus was successfully created.') }
         format.json { render :json => @cursus, 
                        :status  => :created, :location => @cursus }
         else
           format.html { render :action => "new" }
           format.json { render :json => @cursus.errors, 
              :status => :unprocessable_entity }
     format.js {render :layout => false}
      end 
   end
   end
  def update 
    @cursus = Cursus.find(params[:id])
    
    respond_to do |format|
      if @cursus.update_attributes(params[:cursus])
         format.html { redirect_to(@cursus, :notice => 'Cursus was successfuly updated.' )}
          format.json { head :no_content }
        else
          format.html { render :action => "edit"}
          format.json { render :json => @cursus.errors, 
                        :status => :unprocessable_entity  }                   
         format.js {render :layout => false}
         end
    end
  end
  def destroy
  @cursus = Cursus.find(params[:id])
  @cursus.destroy
 
  respond_to do |format|
    format.html { redirect_to cursus_url }
    format.json { head :no_content }
    format.js {render :layout => false}
  end
end
  protected
  
  # Charge toute les entrées cursus dans la variable de classe cursus 
  def load_cursus
      @cursus= Cursus.all
  end
end