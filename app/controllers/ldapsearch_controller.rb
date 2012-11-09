class LdapsearchController < ApplicationController
  unloadable
  before_filter :find_project
  before_filter :authorize

  menu_item :settings
  helper :projects
  helper :sort
  include SortHelper


# Function 
#  search
# redirect
# role_it
# unregistered_user
# not_a_member
#  add
  
# Private:
#  find_project
 
# redefinition simplifié pour une seul entré  
# pas utilisé
def mysearch
   cas = Cas.first
   @ldapusers=[]
   @ldapusers.concat(cas.ldapsearch(params[:firstname],params[:lastname])) unless cas.nil?
   
   @ldapusers = @ldapusers.sort_by{|u| [u[:lastname],u[:firstname]]}
   
   respond_to do |format|
      format.html { render  :controller => 'ldapsearch', 
                            :action=>'index', 
                            :project_id=>@project 
                            }
      format.js { render(:update) {|page|
            page.replace_html "ldapusers", :partial => 'ldapsearch/search'
            page << 'hideOnLoad()'
          }
        }
    end
 end
 
 #TO find what is doing 
  def search
    caslist = []
    params[:cas][:cas_ids].each do |cas_id|
      caslist << Cas.find(cas_id)
    end unless params[:cas].nil?
    
    caslist =  Cas.find(:all) if caslist.empty?
    
    @ldapusers=[]
    caslist.each do |cas|
      @ldapusers.concat(cas.ldapsearch(params[:firstname],params[:lastname])) unless cas.nil?
    end
    
    @ldapusers = @ldapusers.sort_by{|u| [u[:lastname],u[:firstname]]}
    
    respond_to do |format|
      format.html { 
        render :controller => 'ldapsearch',
         :action=>'index', 
         :project_id=>@project 
         }
      format.js { render(:update) {|page|
            page.replace_html "ldapusers", 
            :partial => 'ldapsearch/search'
            page << 'hideOnLoad()'
          }
        }
    end
  end
 
 # redirection vers le projet ()
  def redirect(cas)
    cas = Cas.find(params[:cas_id])
    
    if(params[:login].nil? or params[:cas_id].nil? or cas.nil?)
      redirect_to :action => :index, :project_id => @project
    end
  end

 # definition des rôles
 def role_it
   if params[:roles][:role_ids].nil?
     #N'est plus défini pour l'instant
      roles = [Role.find(Setting.plugin_redmine_rac[:default_role].to_i)]
    else
      roles = []
      params[:roles][:role_ids].each do |r|
        roles << Role.find(r.to_i)
      end
    end
 end 
 
 def unregistered_user(cas)
    user = cas.onthefly(params[:login])
    user.status = User::STATUS_REGISTERED
 end
 
 def not_a_member(user,roles)
   member = Member.new(:user => user, :roles => roles)
        @project.members << member
        blinkid = member.id
 end
 
 def add
    cas = Cas.find(params[:cas_id])
    
    self.redirect(cas)
    roles=self.role_it
    
    user = User.find_by_login(params[:login])
    blinkid = nil
 
    if user.nil?                               # User is unregistered
      self.unregistered_user(cas)
      
      if user.save                              # Saved User
          self.not_a_member(user,roles)
          flash[:notice] = l(:rac_ldap_registered)        
      else
        flash[:error] = l(:notice_account_invalid_creditentials)
      end    
      
    elsif user.cas.url == cas.url              # User already registered
      
      # could be changed as member?
      member = Member.find(:first, :conditions => { :project_id => @project, :user_id => user })
      
      if member.nil?
        self.not_a_member(user,roles)
      else
        flash[:warning] = l(:rac_already_member)
      end
    else                                       # Login conflict
      flash[:error] = l(:rac_userid_exists, params[:login])
    end
    redirect_to :controller => 'projects', :action => 'settings', :tab => 'members', :id => @project, :blinkid => blinkid
  end

private
  def find_project
    @project = Project.find(params[:project_id])
    rescue ActiveRecord::RecordNotFound
      render_404
  end
end