class RemoveUselessTable < ActiveRecord::Migration
  def change
  	drop_table :roles_controller_actions
  end
end
