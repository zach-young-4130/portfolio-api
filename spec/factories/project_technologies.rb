FactoryBot.define do
  factory :project_technology do
    project
    technology
    sequence(:position)
  end
end
