class RemoveControllerFromControllerAction < ActiveRecord::Migration
  def change
  	remove_column :controller_actions, :controller, :string
  end
end
