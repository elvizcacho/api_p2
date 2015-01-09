class AddPermissionsToRoles < ActiveRecord::Migration
  def change
  	controller = ControllerAction.where(name: 'roles', controller_action_id: nil).first
  	ControllerAction.create(:name => "permissions", :controller_action_id => controller.id)
  	action = controller.controller_actions.where(name: 'permissions').first
  	admin = Role.find(1)
  	admin.controller_actions << action
  end
end