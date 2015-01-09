class AddUpdateRole < ActiveRecord::Migration
  def change
  	controller = ControllerAction.where(name: 'users', controller_action_id: nil).first
    action = controller.controller_actions.where(name: 'update').first
    ControllerAction.create(:name => "update role_id", :controller_action_id => action.id)
    ControllerAction.create(:name => "update password", :controller_action_id => action.id)
    admin = Role.find(1);
    admin.controller_actions << action.controller_actions.where(name: 'update role_id').first
    admin.controller_actions << action.controller_actions.where(name: 'update password').first
  end
end
