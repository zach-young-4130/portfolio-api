class AddHighlightsToProjects < ActiveRecord::Migration[8.0]
  def change
    add_column :projects, :highlights, :text
  end
end
