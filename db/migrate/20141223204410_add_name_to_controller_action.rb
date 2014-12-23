class AddNameToControllerAction < ActiveRecord::Migration
  def change
    add_column :controller_actions, :name, :string
  end
end
