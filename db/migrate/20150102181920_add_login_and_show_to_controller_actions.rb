class AddLoginAndShowToControllerActions < ActiveRecord::Migration
  def change
  	ControllerAction.create(:name => "login", :controller_action_id => 1)
  	ControllerAction.create(:name => "show", :controller_action_id => 1)
  end
end
