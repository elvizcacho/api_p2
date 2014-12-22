require 'test_helper'

module Api
    module V1
		class UsersControllerTest < ActionController::TestCase

  			test "should get index" do
    			get :index
    			assert_response :success
    		end

		end
	end
end