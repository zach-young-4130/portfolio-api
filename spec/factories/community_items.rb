FactoryBot.define do
  factory :community_item do
    sequence(:title) { |n| "Community Item #{n}" }
    description { "Description of the community involvement." }
    url { nil }
    role { "Volunteer" }
    year { "2026" }
    sequence(:position) { |n| n }
    published { true }
  end
end
