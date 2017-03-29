class AddDescriptionToSchools < ActiveRecord::Migration[5.0]
  def change
    add_column :schools, :description, :string
  end
end
