class CreateControllerActions < ActiveRecord::Migration
  def change
    create_table :controller_actions do |t|
      t.integer :controller_action_id

      t.timestamps
    end
  end
end
