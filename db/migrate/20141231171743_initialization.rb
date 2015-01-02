class Initialization < ActiveRecord::Migration
  def change
  	Role.create(:name => "admin")
  	ControllerAction.create(:name => "users")
  	ControllerAction.create(:name => "index", :controller_action_id => 1)
  	ControllerAction.create(:name => "create", :controller_action_id => 1)
  	ControllerAction.create(:name => "destroy", :controller_action_id => 1)
    admin = Role.find(1)
  	users = ControllerAction.find(1)
  	admin.controller_actions << users
  	User.create(:name => "Sebastian", :role_id => 1, :email => "admin@gmail.com", :password => "1234")
  end
end
