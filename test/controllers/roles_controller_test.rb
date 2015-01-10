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

        test 'if range header is not set, server response with a 416 status code' do
          get :index, {:token => '0474eee1800353d61a5de09259ee2f9e'}
          assert_response(416, '416 status code')
        end

      # destroy
        test 'if the token is not valid, server response with a 401 status code # destroy' do
          delete :destroy, {:id => '20'}
          assert_response(401, '401 status code')
        end

        test 'only admin can delete roles' do
          delete :destroy, {:id => 2, :token => '0474eee1800353d61a5de09259ee2f9e'}
          begin
            role = Role.find(2)
          rescue Exception => e
            puts "#############{e}################"
          end
          assert_nil(role,'role was deleted by admin')
        end

      # update
        test 'if the token is not valid, server response with a 401 status code # update' do
          put :update, {:id => 1}
          assert_response(401, '401 status code')
        end

      test 'only admin can update a role' do
        put :update, {:id => 1, :token => '0474eee1800353d61a5de09259ee2f9e', :name => 'super'}
        assert(Role.find(1).name == 'super', 'role was updated by admin')
      end

      test 'I should get an array with all the permissions that an admin has' do
        get :show_permissions, {:id => 1, :token => '0474eee1800353d61a5de09259ee2f9e'}
        admin = Role.find(1)
        actions = admin.controller_actions
        i = 0
        for action in actions
          i += 1
        end
        obj = ActiveSupport::JSON.decode(@response.body)
        assert(obj.length == i, 'it returned all permissions')
      end

      test 'I set 4 client role permissions' do
        post :assign_permissions, {:id => 2, :token => '0474eee1800353d61a5de09259ee2f9e', :permissions => '2,3,4,5'}
        n = Role.find(2).controller_actions.length
        assert(n == 4, '4 permissions were set')
      end

	  end
  end
end