require 'test_helper'

module Api
  module V1
	  class UsersControllerTest < ActionController::TestCase

      # index
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

      # destroy
        test 'if the token is not valid, server response with a 401 status code # destroy' do
          delete :destroy, {:id => '20'}
          assert_response(401, '401 status code')
        end

        test 'only admin can delete user accounts' do
          delete :destroy, {:id => 10, :token => '0474eee1800353d61a5de09259ee2f9e'}
          begin
            user = User.find(10)  
          rescue Exception => e
            puts "#############{e}################"
          end
          assert_nil(user,'user was deleted by admin')
        end

        test 'only an user can delete their own account' do
          delete :destroy, {:id => 3, :token => '4e1435bb6c65bf9ca5f298021e18174e'}
          begin
            user2 = User.find(3)
          rescue Exception => e
            puts "#############{e}################"
          end
          assert_not_nil(user2,"user couldn't be deleted by other user different from admin or the owner account")
          delete :destroy, {:id => 2, :token => '4e1435bb6c65bf9ca5f298021e18174e'}
          begin
            user = User.find(2)
          rescue Exception => e
            puts "#############{e}################"
          end
          assert_nil(user,'user was deleted by user')
        end

    # update
      test 'if the token is not valid, server response with a 401 status code # update' do
        put :update, {:id => '21'}
        assert_response(401, '401 status code')
      end

      test 'only admin can update user accounts' do
        put :update, {:id => 11, :token => '0474eee1800353d61a5de09259ee2f9e', :name => 'Ana'}
        puts "username id = 11: #{User.find(11).name}"
        assert(User.find(11).name == 'Ana', 'user was updated by admin')
      end

      test 'only an user can updated their own account' do
        username_before_update = User.find(4).name
        put :update, {:id => 4, :token => '92af12590b11095d5d7828d1a9b7a5e5', :name => "Ana"}
        assert(User.find(4).name == username_before_update, "user couldn't be updated by other user different from admin or the owner account")
        put :update, {:id => 2, :token => '4e1435bb6c65bf9ca5f298021e18174e', :name => "Ana"}
        assert(User.find(2).name == 'Ana', 'user was updated by admin')
      end

    end
	end
end