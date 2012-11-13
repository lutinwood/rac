# Load the normal Rails helr
require File.expand_path(File.dirname(__FILE__) + '../../../../../test/test_helper')

# Ensure that we are using the temporary fixture path
#Engines::Testing.set_fixture_path
ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__) 
