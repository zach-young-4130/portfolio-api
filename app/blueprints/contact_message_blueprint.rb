class ContactMessageBlueprint < Blueprinter::Base
  identifier :id
  fields :name, :email, :message, :read_at, :created_at
end
