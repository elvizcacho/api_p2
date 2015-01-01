class AddUpdateToControllerActions < ActiveRecord::Migration
  def change
  	ControllerAction.create(:name => "update", :controller_action_id => 1)
  end
end
