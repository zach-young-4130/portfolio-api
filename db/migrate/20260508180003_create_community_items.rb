class CreateCommunityItems < ActiveRecord::Migration[8.0]
  def change
    create_table :community_items do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.string :url
      t.string :role
      t.string :year
      t.integer :position
      t.boolean :published, null: false, default: false

      t.timestamps
    end

    add_index :community_items, :position
    add_index :community_items, :published
  end
end
