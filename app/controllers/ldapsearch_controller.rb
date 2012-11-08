class LdapsearchController < ApplicationController
  unloadable
  before_filter :find_project
  before_filter :authorize

  menu_item :settings
  helper :projects
  helper :sort
  include SortHelper

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
      format.html { render :controller => 'ldapsearch', :action=>'index', :project_id=>@project }
      format.js { render(:update) {|page|
            page.replace_html "ldapusers", :partial => 'ldapsearch/search'
            page << 'hideOnLoad()'
          }
        }
    end
  end
  
  def add
    if(params[:login].nil? or params[:cas_id].nil?)
      redirect_to :action => :index, :project_id => @project
    end
    cas = Cas.find(params[:cas_id])
    redirect_to :action => :index, :project_id => @project if cas.nil?
    
    if params[:roles][:role_ids].nil?
      roles = [Role.find(Setting.plugin_redmine_rac[:default_role].to_i)]
    else
      roles = []
      params[:roles][:role_ids].each do |r|
        roles << Role.find(r.to_i)
      end
    end
    
    user = User.find_by_login(params[:login])
    blinkid = nil
    if user.nil?                               # User is unregistered
      user = cas.onthefly(params[:login])
      user.status = User::STATUS_REGISTERED
      if user.save 
        member = Member.new(:user => user, :roles => roles)
        @project.members << member
        flash[:notice] = l(:rac_ldap_registered)
        blinkid = member.id
      else
        flash[:error] = l(:notice_account_invalid_creditentials)
      end    
    elsif user.cas.url == cas.url              # User already registered
      member = Member.find(:first, :conditions => { :project_id => @project, :user_id => user })
      if member.nil?
        member = Member.new(:user => user, :roles => roles)
        @project.members << member
        blinkid = member.id
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
