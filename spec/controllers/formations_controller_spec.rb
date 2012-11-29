require 'spec_helper'

describe FormationsController do
	render_views
	
	describe "GET 'setting'" do 
		it "devrait réussir" do 
			get 'settings/plugin/rac'
			response.should be_success
			end
		end
	describe "GET 'update'" do 
		it "devrait réussir" do
			get 'formations/update'
			response.should be_success
                        end
                end


	end

