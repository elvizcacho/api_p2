class AddRoleIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :role_id, :integer
    add_column :users, :email, :string
    add_column :users, :password, :string
  end
end
