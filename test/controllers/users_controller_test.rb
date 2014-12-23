require 'test_helper'

module Api
    module V1
		class UsersControllerTest < ActionController::TestCase

  			test "should get 10 users" do
  				@request.headers["Accept"] = 'application/x-user+json'
  				@request.headers["Range"] = 'items=0-9'
    			get :index
    			obj = ActiveSupport::JSON.decode(@response.body)
    			assert_response(206, '206 status code')
    			assert(obj.length == 10, 'it returned 10 users')
    		end

        test 'if range header is not set, server response with a 416 status code' do
          get :index
          assert_response(416, '416 status code')
        end


		end
	end
end