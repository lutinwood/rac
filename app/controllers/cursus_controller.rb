class CursusController < ApplicationController
  unloadable
  def index
    @Cursus = Cursus.all
    
    respond_to do | format|
      format.html # index.html.erb
      format.json { render :json => @Cursus}
    end
  end
end