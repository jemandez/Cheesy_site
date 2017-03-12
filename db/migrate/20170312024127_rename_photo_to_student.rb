class RenamePhotoToStudent < ActiveRecord::Migration[5.0]
  def change
    rename_table :photos, :students
    rename_column :students, :collection_id, :group_id
  end
end
