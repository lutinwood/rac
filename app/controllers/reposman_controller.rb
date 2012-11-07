class ReposmanController < ApplicationController
  unloadable
  before_filter :find_project
#  before_filter :authorize
 
  helper :repositories
  include RepositoriesHelper

  def create
    unless ReposmanRequest.pending.creation.find(:all, :conditions => {:project_id => @project}).any?
      @request = ReposmanRequest.new({:project=>@project, :action => 'create'}) if @request.nil?
      @request.options = params[:repository_scm]
      @request.save
      respond_to do |format|
        format.html { render :controller => ':projects', :action=>'settings', :tab => 'repository', :id=>@project }
        format.js { render(:update) {|page|
              page.replace_html "tab-content-repository", :partial => 'projects/settings/repository'
              page << 'hideOnLoad()'
            }
          }
      end
    else
      logger.info "############# OUPS"
      respond_to do |format|
        format.js { render(:update) {|page|
              page.replace_html "tab-content-repository", :partial => 'projects/settings/repository'
              page.alert("Une requête a déjà faite")
            }
          }
      end
    end

  end
  
private

end
