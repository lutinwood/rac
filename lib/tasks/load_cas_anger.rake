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
               :dn => "OU=people,DC=univ-angers,DC=fr") 
   end
end