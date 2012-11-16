require 'rubygems'
require 'casclient'
require 'casclient/frameworks/rails/filter'
require 'net/ldap'

class Cas < ActiveRecord::Base
  
  unloadable
 # has_many :users
# validates_presence_of :url,:ldap,:domain, :username, :password, :port
 
 # Fonctions
  # get_data(login,from)
  # authenticate(controller)
  # is_staff(login)
  # onthefly(login)
  # logout(controller)
  # init_client
 
 def get_data(login,from)
   ### USER ###
   # acces to user fields
   user_data  =  User.find_by_login(login)
   # cas_id field of user table
 #  cas_id = user_data.cas_id
cas_id = 1   
   ### CAS ###
   # acces to cas fields
   cas_data = Cas.find_by_id(cas_id)
   # field field of cas table
   ldap_name = cas_data.ldap
   
   ## LDAP ##
   # acces to ldap field
   ldap_data = AuthSourceLdap.find_by_name(ldap_name)
   
   
   # Composition de requête
   auth = {
      :method => :simple,
      :username => ldap_data.account,
      :password => ldap_data.account_password
    }
     
    ldap_req = Net::LDAP::new :host => ldap_data.host, :port => ldap_data.port , :auth => auth
    filter = Net::LDAP::Filter.eq(ldap_data.attr_login, login)
    # Teacher
    labo = Net::LDAP::Filter.eq(ldap_data.filter, ldap_data.filter_value)
    real_filter = filter & labo
    
    # Informatin to gather from
    attributes = ['givenName', 'sn', 'mail', 'auaStatut', 'eduPersonAffiliation','auaEtapeMillesime', 'supannAffectation']
  
  # CASE
   entry = case from 
   when "staff" then ldap_req.search(:base => ldap_data.base_dn, :filter => real_filter)
   when "onthefly" then ldap_req.search( :base => ldap_data.base_dn, :filter => filter, :attributes => attributes ).first
   end
  # Return
  return entry
 end  
  
  def authenticate(controller)
    init_client
    CASClient::Frameworks::Rails::Filter.filter(controller)
  end

  def is_staff(login)   
    entry = self.get_data(login,'staff')
    return entry
  end
  
  def create_user(login,entry)
    user = User.new
    user.login = login
    user.firstname = entry.givenName.is_a?(Array) ? entry.givenName.first : entry.givenName
    user.lastname = entry.sn.is_a?(Array) ? entry.sn.first : entry.sn
    user.mail = entry.mail.is_a?(Array) ? entry.mail.first : entry.mail
   
    user.cas = self
    
    user.admin = false
    user.status = User::STATUS_ACTIVE
      
 # user.random_password
 # decision de ne pas renseigner le champs password
 # pour un utilisateur identifier par cas 
 
   self.statut(user,entry)
   
    return user 
 end     

  def statut(user,entry)
   
   #
   user.aua_statut = entry.auaStatut.is_a?(Array) ? entry.auaStatut.first : entry.auaStatut
    
    if user.aua_statut == 'etu'
      user.aua_millesime = entry.auaEtapeMillesime.is_a?(Array) ? entry.auaEtapeMillesime.first : entry.auaEtapeMillesime
      elsif user.aua_statut == 'perso'
        user.supann_affectation_last = entry.supannAffectation.is_a?(Array) ? entry.supannAffectation.last : entry.supannAffectation
        else
          'Statut inconnu ! #{eval.user.aua_statut}'
    end
  end 
  
# Utilisateur déjà authentifié
  def onthefly(login)
    # Existe t'il dans le systeme 
    entry = self.get_data(login,'onthefly')
      user = self.create_user(login,entry)
      return user
  end
  
  def logout(controller)
     c = init_client
     controller.send(:reset_session)
     controller.send(:redirect_to, c.logout_url(controller.url_for(:controller=>"welcome")))
  end

private
  def init_client
      CASClient::Frameworks::Rails::Filter.configure(:cas_base_url => self.url)
      return CASClient::Frameworks::Rails::Filter.client
  end
end
