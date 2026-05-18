class CreateProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :projects do |t|
      t.string :title, null: false
      t.string :tagline, null: false
      t.text :description, null: false
      t.string :tech_stack, null: false
      t.string :cover_image_url
      t.string :live_url
      t.string :repo_url
      t.boolean :featured, null: false, default: false
      t.integer :position
      t.boolean :published, null: false, default: false

      t.timestamps
    end

    add_index :projects, :position
    add_index :projects, :published
  end
end
