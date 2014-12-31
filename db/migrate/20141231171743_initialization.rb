class Initialization < ActiveRecord::Migration
  def change
  	Role.create(:id => 1, :name => "admin")
  	ControllerAction.create(:id => 1, :name => "users")
  	ControllerAction.create(:id => 2, :name => "index", controller_action_id: => 1)
  	ControllerAction.create(:id => 3, :name => "create", controller_action_id: => 1)
  	ControllerAction.create(:id => 4, :name => "destroy", controller_action_id: => 1)
  	admin = Role.find(1)
  	users = ControllerAction.find(1)
  	admin.controller_actions << users
  	User.create(:name => "Sebastian", :role_id => 1)
  end
end
