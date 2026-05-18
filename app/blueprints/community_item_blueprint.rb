class CommunityItemBlueprint < Blueprinter::Base
  identifier :id
  fields :title, :description, :url, :role, :year, :position, :published
end
