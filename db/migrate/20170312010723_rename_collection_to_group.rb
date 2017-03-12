class RenameCollectionToGroup < ActiveRecord::Migration[5.0]
  def change
    rename_table :collections, :groups
  end
end
