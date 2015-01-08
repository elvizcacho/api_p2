require 'test_helper'

module Api
  module V1
	  class ControllerActionsControllerTest < ActionController::TestCase
	  	# index
  			test "should get all de data of the model - no range required" do
          number_of_controllers = ControllerAction.where(:controller_action_id => nil).count
  				@request.headers["Accept"] = 'application/x-controller_action+json'
  				get :index, {:token => '0474eee1800353d61a5de09259ee2f9e'}
    			obj = ActiveSupport::JSON.decode(@response.body)
    			assert_response(200, '200 status code')
    			assert(obj.length == number_of_controllers, "it returned #{number_of_controllers} controllers")
    		end
	  end
  end
end