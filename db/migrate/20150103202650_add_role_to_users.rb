class AddRoleToUsers < ActiveRecord::Migration
  def change
  	controller = ControllerAction.where(name: 'users', controller_action_id: nil).first
  	ControllerAction.create(:name => "role", :controller_action_id => controller.id)
  end
end
