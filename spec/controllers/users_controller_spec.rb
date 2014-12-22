require 'rails_helper'

RSpec.describe UsersController, :type => :controller do
	get :index
    assert_response :success
end
