class AddPasswordToGenerations < ActiveRecord::Migration[5.0]
  def change
    add_column :generations, :password_hash, :string
  end
end
