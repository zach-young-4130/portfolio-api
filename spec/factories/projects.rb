FactoryBot.define do
  factory :project do
    sequence(:title) { |n| "Project #{n}" }
    tagline { "A short tagline." }
    description { "A longer description of what this project does." }
    highlights { "Shipped a key feature.\nScaled the system." }
    tech_stack { "Rails, Angular, PostgreSQL" }
    cover_image_url { nil }
    live_url { nil }
    repo_url { nil }
    featured { false }
    sequence(:position) { |n| n }
    published { true }
    project_start { 1.year.ago.to_date }
    project_end { Date.current }
  end
end
