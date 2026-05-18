class FaqItemBlueprint < Blueprinter::Base
  identifier :id
  fields :question, :answer, :position, :published
end
