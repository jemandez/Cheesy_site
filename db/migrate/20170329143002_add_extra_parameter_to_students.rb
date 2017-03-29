class AddExtraParameterToStudents < ActiveRecord::Migration[5.0]
  def change
    add_column :students, :facebook, :string
    add_column :students, :telephone, :string
    add_column :students, :mail, :string
  end
end
