# cas_test.rb
#

# configuration par default
require File.expand_path('../../test_helper', __FILE__)

class CasTest < ActiveSupport::TestCase
  
  #fixtures :ldap, :cas, :user
  
  fixtures  :myusers, :cas
  
  #première methode 
  def test_truth
    assert true
  end
  
end