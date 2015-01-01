class AddRoleClient < ActiveRecord::Migration
  def change
  	Role.create(:id => 2, :name => "client")
  	User.create(:name => "Laura", :role_id => 2)
  	client = Role.find(2)
  	#assigning permissions
  	controller = ControllerAction.where(name: 'users', controller_action_id: nil).first
  	client.controller_actions << controller.controller_actions.where(name: 'destroy').first
  	client.controller_actions << controller.controller_actions.where(name: 'update').first
  end
end
