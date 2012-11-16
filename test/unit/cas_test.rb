# cas_test.rb
#
# configuration par default
require File.expand_path('../../test_helper', __FILE__)

class CasTest < ActiveSupport::TestCase
  
  #fixtures :ldap, :cas, :user
#FIXTURES_PATH = File.join(File.dirname(__FILE__), '../fixtures')
  fixtures :users, :cas
 # def setup
  #    Fixtures.create_fixtures(FIXTURES_PATH,'users')
  #end
  
  #première methode 
  # assert_instance_of( class, obj, [msg] )
  
  def create_ldap
   a = AuthSourceLdap.new(:name =>"Castor2",
:host => 'castor2.info-ua', :port => 389,
:account => "cn=acces-trombi,ou=access,dc=univ-angers,dc=fr",
:account_password => 'bi2tr0',
:base_dn => "OU=people,DC=univ-angers,DC=fr",
:attr_login => "uid",
:attr_firstname => "givenName",
:attr_lastname  =>  "sn",
:attr_mail => "mail",
:filter => "supannAffectation=SI*"
)

 # TESTs ##
        
puts "OUTPUT from create_ldap"
puts a.inspect
puts "--------"

assert a.save
     
  end
  
  
  def test_truth
    mycas = cas(:cas_anger).find
    
    assert_instance_of(cas, mycas)
  end
  

end
