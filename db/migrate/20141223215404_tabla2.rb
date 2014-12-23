class Tabla2 < ActiveRecord::Migration
  
  	
		def change
			create_table :controller_actions_roles, id: false do |t|
				t.belongs_to :role, index: true
				t.belongs_to :controller_action, index: true
			end
		end
	
  
end
