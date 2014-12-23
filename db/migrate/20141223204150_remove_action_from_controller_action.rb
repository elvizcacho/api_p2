class RemoveActionFromControllerAction < ActiveRecord::Migration
  def change
  	remove_column :controller_actions, :action, :string
  end
end
