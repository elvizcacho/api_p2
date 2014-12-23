class AddActionToControllerAction < ActiveRecord::Migration
  def change
    add_column :controller_actions, :action, :string
  end
end
