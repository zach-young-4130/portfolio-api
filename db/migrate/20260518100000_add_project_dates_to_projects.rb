class AddProjectDatesToProjects < ActiveRecord::Migration[8.0]
  def change
    add_column :projects, :project_start, :date
    add_column :projects, :project_end, :date
  end
end
