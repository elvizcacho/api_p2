require 'test_helper'

module Api
  module V1
	  class RolesControllerTest < ActionController::TestCase
	  	# index
  			test "should get 2 roles" do
  				@request.headers["Accept"] = 'application/x-user+json'
  				@request.headers["Range"] = 'items=0-1'
    			get :index, {:token => '0474eee1800353d61a5de09259ee2f9e'}
    			obj = ActiveSupport::JSON.decode(@response.body)
    			assert_response(206, '206 status code')
    			assert(obj.length == 2, 'it returned 2 roles')
    		end
	  end
  end
end