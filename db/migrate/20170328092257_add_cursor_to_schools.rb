class AddCursorToSchools < ActiveRecord::Migration[5.0]
  def change
    add_column :schools, :cursor, :string
    add_column :generations, :cursor, :string
    add_column :groups, :cursor, :string
  end
end
