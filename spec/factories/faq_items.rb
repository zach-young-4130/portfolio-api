FactoryBot.define do
  factory :faq_item do
    sequence(:question) { |n| "Question #{n}?" }
    answer { "An answer." }
    sequence(:position) { |n| n }
    published { true }
  end
end
