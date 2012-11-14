###################################
# => Ajout des informations LDAP  #
###################################
 
def addldap(values)
  ldap = AuthSourceLdap.find_or_initialize_by_identifier(values)
  if ldap.new_record?
    puts "Ldap added for #{ldap.name}." if ldap.save
  end
end

desc 'Load LDAP in database.'
namespace :ang do
  task :load_ldap => :environment do
    addldap(  :type => "AuthsourceLdap", \
              :name => "Castor2", \
              :host => "castor2.info-ua" ,\
              :port => 389, \
              :account => "cn=acces-trombi,ou=access,dc=univ-angers,dc=fr", \
              :account_password => 'bi2tr0', \
              :base_dn => "OU=people,DC=univ-angers,DC=fr", \
              :attr_login => "uid", \
              :attr_firstname => "givenName", \
              :attr_lastname  =>  "sn", \
              :attr_mail => "mail", \
              :onthefly_register => TRUE, \
              :tls => TRUE , \
              :filter => 'supannAffectation', \
              #to add in db 
              :filter_value => "SI*" \
            )
  end 
end

#################################
# => Ajout des informations CAS #
#################################

def addcas(values)
  cas = Cas.find_or_initialize_by_identifier(values)
  if cas.new_record?
    puts "CAS added for #{cas.name}." if cas.save
  end
end

desc 'Load CAS in database.'
namespace :ang do
  task :load_cas => :environment do
   addcas(:identifier =>"angcas", \
               :url => "https://cas.univ-angers.fr/cas", \
               :ldap => "Castor2" )
   end
end