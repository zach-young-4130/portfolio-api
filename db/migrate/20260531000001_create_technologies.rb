class CreateTechnologies < ActiveRecord::Migration[8.0]
  def change
    create_table :technologies do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :category

      t.timestamps
    end

    add_index :technologies, :name, unique: true
    add_index :technologies, :slug, unique: true
    add_index :technologies, :category
  end
end
