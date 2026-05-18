FactoryBot.define do
  factory :contact_message do
    sequence(:name) { |n| "Visitor #{n}" }
    sequence(:email) { |n| "visitor#{n}@example.com" }
    message { "Hello, I'd like to connect." }
    read_at { nil }
  end
end
