class PageViewBlueprint < Blueprinter::Base
  identifier :id
  fields :path, :city, :region, :country, :created_at
end
