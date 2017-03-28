class AddDropboxColumnsToSchool < ActiveRecord::Migration[5.0]
  def change
    add_column :schools, :did, :string
    add_column :schools, :dpath, :string

    add_column :students, :did, :string
    add_column :students, :dpath, :string

    add_column :groups, :did, :string
    add_column :groups, :dpath, :string

    add_column :generations, :did, :string
    add_column :generations, :dpath, :string

    rename_column :schools, :name, :title
  end
end
