class UserBlueprint < Blueprinter::Base
  identifier :id
  fields :email, :name, :avatar_url, :role
end
