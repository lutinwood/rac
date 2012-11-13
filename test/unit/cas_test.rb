# cas_test.rb
#
# configuration par default
require File.expand_path('../../test_helper', __FILE__)

class CasTest < ActiveSupport::TestCase
  
  #fixtures :ldap, :cas, :user
#FIXTURES_PATH = File.join(File.dirname(__FILE__), '../fixtures')
  fixtures :users
 # def setup
  #    Fixtures.create_fixtures(FIXTURES_PATH,'users')
  #end
  
  #première methode 
  def test_truth
    assert true
  end
  
end
