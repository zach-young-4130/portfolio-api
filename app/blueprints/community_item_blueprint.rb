class CommunityItemBlueprint < Blueprinter::Base
  identifier :id
  fields :title, :description, :url, :role, :year, :tech_stack, :position, :published
end
