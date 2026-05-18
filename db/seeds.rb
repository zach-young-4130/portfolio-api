# Idempotent seeding. Reads admin credentials from Rails encrypted credentials.
#
# To set them, run:
#   bin/rails credentials:edit
# and add:
#   admin:
#     email: you@example.com
#     password: a-strong-password
#
# Then seed with:
#   bin/rails db:seed

admin = Rails.application.credentials.admin

if admin.blank? || admin[:email].blank? || admin[:password].blank?
  abort <<~MSG
    Admin credentials are missing from Rails encrypted credentials.
    Run `bin/rails credentials:edit` and add:

      admin:
        email: you@example.com
        password: a-strong-password
  MSG
end

User.find_or_initialize_by(email: admin[:email]).tap do |user|
  user.password = admin[:password]
  user.save!
end

# --- Sample content ---------------------------------------------------------

projects = [
  {
    title: "Portfolio Site",
    tagline: "This very site you're looking at.",
    description: "Rails 8 API + Angular 21 SSR + Bootstrap. Light/dark themes, accessible by default, and an admin CMS for managing content.",
    tech_stack: "Rails 8, Angular 21, Bootstrap 5, PostgreSQL",
    cover_image_url: nil,
    live_url: nil,
    repo_url: nil,
    featured: true,
    position: 1,
    published: true
  },
  {
    title: "Open Source Contribution",
    tagline: "Patches & PRs to projects I rely on.",
    description: "Various contributions to open-source libraries used in production systems.",
    tech_stack: "Ruby, TypeScript",
    featured: true,
    position: 2,
    published: true
  },
  {
    title: "Side Project",
    tagline: "A weekend experiment.",
    description: "An experiment in API design and front-end architecture.",
    tech_stack: "Rails, Hotwire",
    featured: false,
    position: 3,
    published: true
  }
]

projects.each do |attrs|
  Project.find_or_initialize_by(title: attrs[:title]).update!(attrs)
end

faq_items = [
  {
    question: "What stack do you specialize in?",
    answer: "Ruby on Rails on the backend and Angular or Hotwire on the frontend, with PostgreSQL.",
    position: 1,
    published: true
  },
  {
    question: "Are you available for freelance work?",
    answer: "No, who has the time for that with a full-time job? Legitimate question. I focus on what I am working on, who I'm working for, where I'm working at, and the output of the work I produce.",
    position: 2,
    published: true
  },
  {
    question: "Where are you based?",
    answer: "United States, with most of my collaboration done remotely.",
    position: 3,
    published: true
  }
]

faq_items.each do |attrs|
  FaqItem.find_or_initialize_by(question: attrs[:question]).update!(attrs)
end

community_items = [
  {
    title: "Local meetup talks",
    description: "Occasional speaker at regional Ruby and Angular meetups.",
    role: "Speaker",
    year: "2025",
    position: 1,
    published: true
  },
  {
    title: "Open-source maintenance",
    description: "Maintaining a small handful of utility libraries.",
    role: "Maintainer",
    year: "Ongoing",
    position: 2,
    published: true
  }
]

community_items.each do |attrs|
  CommunityItem.find_or_initialize_by(title: attrs[:title]).update!(attrs)
end
