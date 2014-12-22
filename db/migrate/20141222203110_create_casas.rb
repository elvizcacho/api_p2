class CreateCasas < ActiveRecord::Migration
  def change
    create_table :casas do |t|
      t.string :direccion

      t.timestamps
    end
  end
end
