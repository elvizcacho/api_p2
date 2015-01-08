class ControllerActionsActions < ActiveRecord::Migration
  def change
  	#creates controller
  	ControllerAction.create(:name => "controller_actions")
  	controller = ControllerAction.where(name: 'controller_actions', controller_action_id: nil).first
  	ControllerAction.create(:name => "index", :controller_action_id => controller.id)
  	admin = Role.find(1)
  	admin.controller_actions << controller
  end
end
