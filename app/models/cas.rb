require 'rubygems'
require 'casclient'
require 'casclient/frameworks/rails/filter'
require 'net/ldap'

class Cas < ActiveRecord::Base
  unloadable
  has_many :users

  validates_presence_of :url,:ldap,:dn

  def authenticate(controller)
    init_client
    CASClient::Frameworks::Rails::Filter.filter(controller)
  end

  #is_staff?
  def is_staff(login)
    myldap = AuthSource.find_by_host(self.ldap)
    auth = {:method => :simple, :username => myldap.account, :password => myldap.account_password}
    ldap = Net::LDAP::new :host => myldap.host, :port => myldap.port, :auth => auth
    filter = Net::LDAP::Filter.eq(myldap.attr_login, login)
    labo = Net::LDAP::Filter.eq('supannAffectation', 'SI*')
    real_filter = filter & labo
    entry = ldap.search(:base => myldap.base_dn, :filter => real_filter  )
    return entry
  end


def onthefly(login) 
 begin
   # récupération des information ldap stocké en base
   myldap = AuthSource.find_by_host(self.ldap)
   # définition de la requête
   auth = {:method => :simple, :username => myldap.account, :password => myldap.account_password}
   ldap = Net::LDAP::new :host => self.ldap, :port => '389', :auth => auth
    #raise Exception, myldap.inspect
    
end
    filter = Net::LDAP::Filter.eq('uid', login)
    attributes = ['givenName', 'sn', 'mail', 'auaStatut', 'eduPersonAffiliation','auaEtapeMillesime', 'supannAffectation']
    entry = ldap.search( :base => self.dn, :filter => filter, :attributes => attributes ).first
    if entry
logger.debug entry.inspect
      user = User.new
      user.login = login
      user.firstname = entry.givenName.is_a?(Array) ? entry.givenName.first : entry.givenName
      user.lastname = entry.sn.is_a?(Array) ? entry.sn.first : entry.sn 
      user.mail = entry.mail.is_a?(Array) ? entry.mail.first : entry.mail
      user.cas = self
      #ajouter univ-angers
      user.aua_statut = entry.auaStatut.is_a?(Array) ? entry.auaStatut.first : entry.auaStatut
     logger.debug  user.inspect 
     
      user.supann_affectation_first = entry.supannAffectation.is_a?(Array) ? entry.supannAffectation.first : entry.supannAffectation
      if user.aua_statut == 'etu'
        user.aua_millesime = entry.auaEtapeMillesime.is_a?(Array) ? entry.auaEtapeMillesime.first : entry.auaEtapeMillesime
      elsif user.aua_statut == 'perso'
        user.supann_affectation_last = entry.supannAffectation.is_a?(Array) ? entry.supannAffectation.last : entry.supannAffectation
      else
        begin 
         'Statut inconnu ! #{eval.user.aua_statut}'
      end
      end
      #
      user.admin = false
      user.status = User::STATUS_ACTIVE

      # Generate and set a random password.
      chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
      password = ''
      40.times { |i| password << chars[rand(chars.size-1)] } 
      user.password = password 
      user.password_confirmation = password
      return user
 
    end
 
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
