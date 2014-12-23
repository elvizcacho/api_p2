class AddControllerToControllerAction < ActiveRecord::Migration
  def change
    add_column :controller_actions, :controller, :string
  end
end
