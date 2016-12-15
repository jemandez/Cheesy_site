class CreateCollections < ActiveRecord::Migration[5.0]
  def change
    create_table :collections do |t|
      t.string :title
      t.text :description
      t.string :photos

      t.timestamps
    end
  end
end
