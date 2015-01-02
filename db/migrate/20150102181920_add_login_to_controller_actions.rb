class AddLoginToControllerActions < ActiveRecord::Migration
  def change
  	ControllerAction.create(:name => "login", :controller_action_id => 1)
  end
end
