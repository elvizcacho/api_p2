class RolesControllerActions < ActiveRecord::Migration
def change
create_table :roles_controller_actions, id: false do |t|
t.belongs_to :role, index: true
t.belongs_to :controller_action, index: true
end
end
end
