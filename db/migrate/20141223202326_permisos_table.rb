class PermisosTable < ActiveRecord::Migration
  def change
  	create_table :roles_controller_actions do |t|
  	  t.integer :role_id
      t.integer :controller_action_id
      t.timestamps
  	end
  end
end