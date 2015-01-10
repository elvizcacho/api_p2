class AddPermissionsToUsersDestroy < ActiveRecord::Migration
  def change
  	controller = ControllerAction.where(name: 'users', controller_action_id: nil).first
    action = controller.controller_actions.where(name: 'destroy').first
    ControllerAction.create(:name => "destroy other users", :controller_action_id => action.id)
    ControllerAction.create(:name => "destroy itself", :controller_action_id => action.id)
    admin = Role.find(1);

    admin.controller_actions << action.controller_actions.where(name: 'destroy other users').first
    admin.controller_actions << action.controller_actions.where(name: 'destroy itself').first

    client = Role.find(2);
    client.controller_actions << action.controller_actions.where(name: 'destroy itself').first
  end
end
