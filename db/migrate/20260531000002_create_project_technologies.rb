class CreateProjectTechnologies < ActiveRecord::Migration[8.0]
  def change
    create_table :project_technologies do |t|
      t.references :project, null: false, foreign_key: true
      t.references :technology, null: false, foreign_key: true
      t.integer :position

      t.timestamps
    end

    add_index :project_technologies, %i[project_id technology_id], unique: true
    add_index :project_technologies, :position
  end
end
