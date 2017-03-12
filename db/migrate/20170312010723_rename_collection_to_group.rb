class RenameCollectionToGroup < ActiveRecord::Migration[5.0]
  def change
    rename_table :collections, :groups
    rename_column :groups, :event_id, :generation_id
  end
end
