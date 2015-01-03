class AddUpdatePasswordToUsers < ActiveRecord::Migration
  def change
  	controller = ControllerAction.where(name: 'users', controller_action_id: nil).first
  	ControllerAction.create(:name => "update_password", :controller_action_id => controller.id)
  	client = Role.find(2)
  	client.controller_actions << controller.controller_actions.where(name: 'update_password').first
  end
end
