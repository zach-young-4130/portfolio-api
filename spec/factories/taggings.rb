FactoryBot.define do
  factory :tagging do
    tag
    association :taggable, factory: :project
  end
end
