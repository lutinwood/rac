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
  
  def test_truth
    mycas = cas(:cas_anger).find
    
    assert_instance_of(cas, mycas)
  end
  

end
