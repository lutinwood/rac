def addcas(values)
  cas = Cas.find_or_initialize_by_identifier(values)
  if cas.new_record?
    puts "CAS added for #{cas.name}." if cas.save
  end
end

desc 'Load CAS in database.'
namespace :ang do
  task :load_cas => :environment do
   addcas(:name=>"CAS ANGERS", \
               :identifier =>"angcas", \
               :url => "https://cas.univ-angers.fr/cas", \
               :ldap => "castor2.info-ua", \
               :domain => "OU=people,DC=univ-angers,DC=fr", \
               :port => 389,\
               :username => 'cn=acces-trombi,ou=access,dc=univ-angers,dc=fr', \
               :password => 'bi2tr0', \
               :filter_user => 'uid', \
               :filter_group => 'supannAffectation', \
               :filter_group_value => 'SI*'\
               ) 
   end
end