class AddPermissionsToUsersUpdatePassword < ActiveRecord::Migration
  def change
  	controller = ControllerAction.where(name: 'users', controller_action_id: nil).first
    action = controller.controller_actions.where(name: 'update_password').first
    ControllerAction.create(:name => "update other users password", :controller_action_id => action.id)
    ControllerAction.create(:name => "update own user password", :controller_action_id => action.id)
    admin = Role.find(1);

    admin.controller_actions << action.controller_actions.where(name: 'update other users password').first
    admin.controller_actions << action.controller_actions.where(name: 'update own user password').first

    client = Role.find(2);
    client.controller_actions << action.controller_actions.where(name: 'update own user password').first
  end
end
