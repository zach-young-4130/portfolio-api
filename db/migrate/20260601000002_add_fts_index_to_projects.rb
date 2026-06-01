class AddFtsIndexToProjects < ActiveRecord::Migration[8.0]
  def up
    execute <<~SQL
      CREATE INDEX index_projects_on_fts ON projects USING gin ((
        setweight(to_tsvector('english', coalesce(title, '')),     'A') ||
        setweight(to_tsvector('english', coalesce(tagline, '')),    'A') ||
        setweight(to_tsvector('english', coalesce(tech_stack, '')), 'B') ||
        setweight(to_tsvector('english', coalesce(description, '')), 'C')
      ));
    SQL
  end

  def down
    execute "DROP INDEX IF EXISTS index_projects_on_fts;"
  end
end
