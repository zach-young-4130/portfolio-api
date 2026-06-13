class ProjectBlueprint < Blueprinter::Base
  identifier :id
  fields :title, :tagline, :description, :highlights, :tech_stack,
         :cover_image_url, :live_url, :repo_url,
         :featured, :position, :published,
         :project_start, :project_end

  association :technologies, blueprint: TechnologyBlueprint
  association :tags, blueprint: TagBlueprint
end
