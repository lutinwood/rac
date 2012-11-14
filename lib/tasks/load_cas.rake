def addcas(values)
  cas = Cas.find_or_initialize_by_identifier(values)
  if cas.new_record?
    puts "CAS added for #{cas.name}." if cas.save
  end
end

desc 'Load CAS in database.'
namespace :rac do
  task :load_cas => :environment do
   addcas(:identifier =>"dummy", \
               :url => "https://dummy/cas", \
               :ldap => "ldap.dummy.fr", \
               :dn => "dc=dummy,dc=fr") 
   end
end

