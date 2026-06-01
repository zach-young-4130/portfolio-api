FactoryBot.define do
  factory :technology do
    sequence(:name) { |n| "Technology #{n}" }
    sequence(:slug) { |n| "technology-#{n}" }
    category { "framework" }
  end
end
