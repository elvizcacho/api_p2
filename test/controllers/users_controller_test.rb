require 'test_helper'


class UsersControllerTest < ActionController::TestCase

	def setup
    	@controller = UsersController.new
  	end
RSpec.describe 'get index' do
  test "should get index" do
    get :index
    assert_response :success
  end
end
end