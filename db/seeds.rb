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
  user.role     = "admin"
  user.save!
end

# --- Sample content ---------------------------------------------------------

projects = [
  {
    title: "Traction Studio AI",
    tagline: "ESO and Admin dashboards powered by Rails 8 + Hotwire.",
    description: "Architected ESO and Admin dashboards using Rails 8 + Hotwire for real-time UI without a JS framework. Engineered Stripe payment integration covering retail and scholarship transaction flows. Implemented a Light/Dark mode system with Tailwind CSS custom properties.",
    tech_stack: "Rails 8, Hotwire, PostgreSQL, Redis, Sidekiq, Tailwind CSS, Stripe",
    cover_image_url: "/screenshots/tractionstudio.jpg",
    live_url: "https://app.tractionstudio.ai/users/sign_up/founder",
    repo_url: nil,
    featured: true,
    position: 1,
    published: true,
    project_start: "2025-08-01",
    project_end: "2026-05-01"
  },
  {
    title: "IHM Used Parts",
    tagline: "E-commerce platform for 500,000+ heavy equipment parts.",
    description: "Built a decoupled e-commerce and inventory platform with a Rails 8 API backend and Angular frontend from the ground up. Managed a catalog of 500,000+ parts with sub-second search latency and a complex parts-filtering and quote workflow. Integrated Authorize.net for payment processing across the full purchase and checkout flow.",
    tech_stack: "Rails 8, Angular, PostgreSQL, Authorize.net, REST API",
    cover_image_url: "/screenshots/ihmusedparts.jpg",
    live_url: "https://ihmusedparts.com",
    repo_url: nil,
    featured: true,
    position: 2,
    published: true,
    project_start: "2023-01-01",
    project_end: "2025-04-01"
  },
  {
    title: "SR Harvesting",
    tagline: "Seed delivery tracking from harvester to semi truck trailer.",
    description: "Built a seed delivery tracking application for farmers to manage loads moving from harvester to cart to semi truck trailer. Designed a ticketing system that generated unique receipt numbers capturing farm, field, and load data at each transfer point. Enabled end-to-end traceability of seed and product delivery from the field to the scale or silo.",
    tech_stack: "Angular 18, Ionic 8, Rails API, PostgreSQL",
    cover_image_url: "/screenshots/srharvestingapp.jpg",
    live_url: "https://harvesting.supremerice.com",
    repo_url: nil,
    featured: false,
    position: 3,
    published: true,
    project_start: "2023-01-01",
    project_end: nil
  },
  {
    title: "Parent ProTech",
    tagline: "Curriculum and video delivery platform for school districts.",
    description: "Re-engineered the core platform to support a growing curriculum ecosystem used by school districts. Built and managed the video delivery pipeline for on-demand educational content. Designed integrations with school district systems to automate enrollment and reporting workflows.",
    tech_stack: "Rails API, Angular SSR, Video Streaming, PostgreSQL",
    cover_image_url: "/screenshots/parentprotech.jpg",
    live_url: "https://www.parentprotech.com",
    repo_url: nil,
    featured: false,
    position: 4,
    published: true,
    project_start: "2022-07-01",
    project_end: "2025-03-01"
  },
  {
    title: "PumpTrakr",
    tagline: "Remotely control and monitor farm irrigation — pumps, pivots, water, and fuel.",
    description: "A farmer-owned platform for running an entire irrigation operation from a single mobile app — switching flood pumps and center pivots on or off, setting pivot direction and run times, and tracking water depth, fuel levels, and maintenance alerts in real time. I built the operator-facing dashboard across two major versions (v1 → v2), engineering the real-time sensor visualization field teams rely on to manage pumps and pivots spread across large properties. On the Rails API, I implemented tiered admin and superadmin access control — giving platform operators scoped management of devices, accounts, and farm data.",
    tech_stack: "Angular, Rails API, Real-time Data, Data Visualization",
    cover_image_url: "/screenshots/pumptrakr.jpg",
    live_url: "https://pumptrakr.com",
    repo_url: nil,
    featured: true,
    position: 5,
    published: true,
    project_start: "2018-01-01",
    project_end: "2024-10-01"
  },
  {
    title: "Venku",
    tagline: "v2 modernization of an outdoor recreation marketplace.",
    description: "Led full v2 modernization of an outdoor recreation marketplace for guided hunts and fishing, migrating Angular v4 to v12. Upgraded the backend API from .NET Core 2.1 to 3.1 alongside the frontend migration. Engineered a Hapi.js search microservice backed by MongoDB. Scaled the platform to support 10,000+ active users and managed a database of 1,000+ verified outfitters.",
    tech_stack: "Angular 12, Node.js, MongoDB, Microservices",
    cover_image_url: "/screenshots/venku.jpg",
    live_url: "https://venku.com",
    repo_url: nil,
    featured: false,
    position: 6,
    published: true,
    project_start: "2018-03-01",
    project_end: "2023-03-01"
  },
  {
    title: "CarGo Eats",
    tagline: "Food ordering and delivery platform within the CarGo ecosystem.",
    description: "Built the web application for CarGo Eats, a food ordering and delivery service within the CarGo ecosystem. Implemented Angular SSR for improved load performance and SEO across the ordering experience. Integrated with multiple microservices to handle menu management, order routing, and delivery tracking.",
    tech_stack: "Angular SSR, Microservices, TypeScript, REST API",
    cover_image_url: nil,
    live_url: nil,
    repo_url: nil,
    featured: false,
    position: 7,
    published: true,
    project_start: "2019-01-01",
    project_end: "2020-12-01"
  },
  {
    title: "Careerquo / Upsquad",
    tagline: "Career development platform, later rebranded as Upsquad.",
    description: "Developed the full application for a career development platform, later rebranded as Upsquad. Built an Angular frontend paired with a Node.js backend to deliver a seamless user experience. Designed data models and API layer backed by MongoDB for flexible career profile management.",
    tech_stack: "Angular, Node.js, MongoDB, REST API",
    cover_image_url: "/screenshots/upsquad.jpg",
    live_url: "https://upsquad.co",
    repo_url: nil,
    featured: false,
    position: 8,
    published: true,
    project_start: "2018-09-01",
    project_end: "2020-07-01"
  },
  {
    title: "CarGo Courier",
    tagline: "B2B delivery platform coordinating pickup and delivery via CarGo.",
    description: "Built a B2B delivery platform enabling businesses to request and manage goods pickup and delivery via CarGo. Developed a full-stack Rails application coordinating with multiple microservices to fulfill delivery workflows end-to-end. Designed the service integration layer for real-time dispatch communication across the courier network.",
    tech_stack: "Rails, Microservices, PostgreSQL, REST API",
    cover_image_url: nil,
    live_url: nil,
    repo_url: nil,
    featured: false,
    position: 9,
    published: true,
    project_start: "2017-03-01",
    project_end: "2020-03-01"
  },
  {
    title: "Buchheit's",
    tagline: "Maintenance and feature work on the Angular frontend for a retail chain.",
    description: "Served in a maintenance role on the Angular frontend, keeping the e-commerce experience stable and delivering incremental improvements. The frontend communicated with a microservices backend to handle product catalog, inventory, and checkout flows.",
    tech_stack: "Angular, Microservices, REST API",
    cover_image_url: "/screenshots/buchheits.jpg",
    live_url: "https://www.buchheits.com",
    repo_url: nil,
    featured: false,
    position: 10,
    published: true,
    project_start: "2018-01-01",
    project_end: "2019-12-01"
  },
  {
    title: "Hodlit",
    tagline: "Customer service and admin/super-admin dashboard for a consumer platform.",
    description: "Led frontend engineering for the customer service and admin/super-admin dashboard in Angular, delivered through Codefi Works. Designed tiered admin interfaces enabling internal teams to manage users, resolve support requests, and perform elevated platform operations.",
    tech_stack: "Angular, REST API, TypeScript",
    cover_image_url: "/screenshots/hodlit.jpg",
    live_url: "https://hodlit.com",
    repo_url: nil,
    featured: false,
    position: 11,
    published: true,
    project_start: "2018-01-01",
    project_end: "2018-12-01"
  }
]

seeded_project_ids = projects.map do |attrs|
  project = Project.find_or_initialize_by(title: attrs[:title])
  project.update!(attrs)
  project.id
end

Project.where.not(id: seeded_project_ids).destroy_all

faq_items = [
  {
    question: "What stack do you specialize in?",
    answer: "I specialize in Rails API-only or full-stack using JS frameworks like Hotwire, Turbo, and Stimulus or TypeScript Angular.",
    position: 1,
    published: true
  },
  {
    question: "Are you available for work?",
    answer: "Yes — and actively looking for my next role. Full-time or contract, remote, I'm open to the right opportunity. If you've got a role or project in mind, reach out through the <a href=\"/contact\">contact form</a> and I'll get back to you quickly.",
    position: 2,
    published: true
  },
  {
    question: "Where are you based?",
    answer: "Cape Girardeau, Missouri — CDT/CST. I collaborate remotely and am comfortable working with teams across US time zones.",
    position: 3,
    published: true
  },
  {
    question: "What industries have you shipped production software in?",
    answer: "Ag-tech, e-commerce, ed-tech, fin-tech, food delivery, outdoor recreation, career development, and AI. Each domain came with its own constraints and I had to learn it fast — that breadth has made me a quicker, more adaptable engineer.",
    position: 4,
    published: true
  },
  {
    question: "Do you mentor or teach other developers?",
    answer: "Yes. I've served as an Instructor and Lead Co-Instructor for Code Labs, a 20-week intensive program that takes people from little or no coding experience to entry-level programmers. Teaching forces you to understand things at a deeper level — it's made me a better engineer.",
    position: 5,
    published: true
  },
  {
    question: "What's the largest-scale system you've worked on?",
    answer: "A few stand out. IHM Used Parts — an e-commerce platform managing 500,000+ heavy equipment parts with sub-second search across the full catalog. Venku — an outdoor recreation marketplace scaled to 10,000+ active users with 1,000+ verified outfitters. SR Harvesting — a seed delivery tracking system handling end-to-end traceability across farm, field, and load at every transfer point.",
    position: 6,
    published: true
  },
  {
    question: "How do you prefer to collaborate with product teams?",
    answer: "Directly. I'd rather have a 10-minute conversation than a week of back-and-forth tickets. I ask questions early, flag tradeoffs when I see them, and try to ship things that don't need a follow-up PR to fix.",
    position: 7,
    published: true
  },
  {
    question: "How is this portfolio hosted?",
    answer: "The Angular frontend is deployed on Vercel. The Rails API, PostgreSQL database, and all backend infrastructure are hosted and deployed on Fly.io.",
    position: 8,
    published: true
  }
]

# Upsert by question, then prune any FAQ not in the current list so renamed or
# removed questions don't linger as orphans on re-seed.
seeded_faq_ids = faq_items.map do |attrs|
  item = FaqItem.find_or_initialize_by(question: attrs[:question])
  item.update!(attrs)
  item.id
end

FaqItem.where.not(id: seeded_faq_ids).destroy_all

community_items = [
  {
    title: "Code Labs",
    description: "A 20-week intensive training program taking applicants from little to no coding experience to entry-level programmers. Responsible for delivering curriculum, leading hands-on labs, and mentoring students through the full program.",
    role: "Instructor",
    year: "2018 – 2019",
    tech_stack: "HTML, CSS, JavaScript, Rails",
    position: 1,
    published: true
  },
  {
    title: "Code Labs",
    description: "A 20-week intensive training program taking applicants from little to no coding experience to entry-level programmers. Responsible for delivering curriculum, leading hands-on labs, and mentoring students through the full program.",
    role: "Instructor",
    year: "2020 – 2021",
    tech_stack: "HTML, CSS, JavaScript, Angular, Rails",
    position: 2,
    published: true
  },
  {
    title: "Code Labs",
    description: "A 20-week intensive training program taking applicants from little to no coding experience to entry-level programmers. Coordinated curriculum delivery alongside the lead instructor, led sessions, and provided direct mentorship across the cohort.",
    role: "Lead Co-Instructor",
    year: "2022 – 2023",
    tech_stack: "HTML, CSS, JavaScript, Angular, Rails",
    position: 3,
    published: true
  }
]

# Upsert by title + role + year — all three share the same title, and two share
# the same role, so year is needed to uniquely identify each record.
seeded_ids = community_items.map do |attrs|
  item = CommunityItem.find_or_initialize_by(title: attrs[:title], role: attrs[:role], year: attrs[:year])
  item.update!(attrs)
  item.id
end

CommunityItem.where.not(id: seeded_ids).destroy_all

# --- Technologies ------------------------------------------------------------

technologies_data = [
  { name: "Ruby on Rails", slug: "ruby-on-rails",  category: "framework" },
  { name: "Angular",       slug: "angular",         category: "framework" },
  { name: "Hotwire",       slug: "hotwire",         category: "framework" },
  { name: "Ionic",         slug: "ionic",           category: "framework" },
  { name: "TypeScript",    slug: "typescript",      category: "language"  },
  { name: "JavaScript",    slug: "javascript",      category: "language"  },
  { name: "PostgreSQL",    slug: "postgresql",      category: "platform"  },
  { name: "Redis",         slug: "redis",           category: "platform"  },
  { name: "MongoDB",       slug: "mongodb",         category: "platform"  },
  { name: "Node.js",       slug: "nodejs",          category: "platform"  },
  { name: "Sidekiq",       slug: "sidekiq",         category: "tool"      },
  { name: "Stripe",        slug: "stripe",          category: "tool"      },
  { name: "Authorize.net", slug: "authorize-net",   category: "tool"      },
  { name: "Tailwind CSS",  slug: "tailwind-css",    category: "library"   },
  { name: "Bootstrap",     slug: "bootstrap",       category: "library" }
]

tech_by_slug = technologies_data.each_with_object({}) do |attrs, map|
  tech = Technology.find_or_initialize_by(slug: attrs[:slug])
  tech.update!(attrs)
  map[attrs[:slug]] = tech
end

Technology.where.not(slug: tech_by_slug.keys).destroy_all

# --- Tags --------------------------------------------------------------------

tags_data = [
  { name: "ag-tech",            slug: "ag-tech"            },
  { name: "ai",                 slug: "ai"                 },
  { name: "b2b",                slug: "b2b"                },
  { name: "career-tech",        slug: "career-tech"        },
  { name: "e-commerce",         slug: "e-commerce"         },
  { name: "ed-tech",            slug: "ed-tech"            },
  { name: "food-delivery",      slug: "food-delivery"      },
  { name: "marketplace",        slug: "marketplace"        },
  { name: "mobile",             slug: "mobile"             },
  { name: "outdoor-recreation", slug: "outdoor-recreation" },
  { name: "real-time",          slug: "real-time" },
  { name: "fin-tech",           slug: "fin-tech" }
]

tag_by_slug = tags_data.each_with_object({}) do |attrs, map|
  tag = Tag.find_or_initialize_by(slug: attrs[:slug])
  tag.update!(attrs)
  map[attrs[:slug]] = tag
end

Tag.where.not(slug: tag_by_slug.keys).destroy_all

# --- Project associations ----------------------------------------------------

project_tech_map = {
  "Traction Studio AI"  => %w[ruby-on-rails hotwire postgresql redis sidekiq tailwind-css stripe],
  "IHM Used Parts"      => %w[ruby-on-rails angular postgresql authorize-net],
  "SR Harvesting"       => %w[angular ionic ruby-on-rails postgresql],
  "Parent ProTech"      => %w[ruby-on-rails angular postgresql],
  "PumpTrakr"           => %w[angular ruby-on-rails postgresql],
  "Venku"               => %w[angular nodejs mongodb],
  "CarGo Eats"          => %w[angular typescript],
  "Careerquo / Upsquad" => %w[angular nodejs mongodb],
  "CarGo Courier"       => %w[ruby-on-rails postgresql],
  "Buchheit's"          => %w[angular],
  "Hodlit"              => %w[angular typescript bootstrap]
}

project_tag_map = {
  "Traction Studio AI"  => %w[ai],
  "IHM Used Parts"      => %w[e-commerce marketplace],
  "SR Harvesting"       => %w[ag-tech mobile],
  "Parent ProTech"      => %w[ed-tech],
  "PumpTrakr"           => %w[ag-tech real-time],
  "Venku"               => %w[outdoor-recreation marketplace],
  "CarGo Eats"          => %w[food-delivery],
  "Careerquo / Upsquad" => %w[career-tech],
  "CarGo Courier"       => %w[b2b],
  "Buchheit's"          => %w[e-commerce],
  "Hodlit"              => %w[fin-tech]
}

project_tech_map.each do |title, slugs|
  project = Project.find_by!(title: title)
  project.technologies = slugs.map { |s| tech_by_slug[s] }.compact
end

project_tag_map.each do |title, slugs|
  project = Project.find_by!(title: title)
  project.tags = slugs.map { |s| tag_by_slug[s] }.compact
end

# --- Community item associations ---------------------------------------------

community_tag_map = [
  { title: "Code Labs", role: "Instructor",       year: "2018 – 2019", tags: %w[ed-tech] },
  { title: "Code Labs", role: "Instructor",       year: "2020 – 2021", tags: %w[ed-tech] },
  { title: "Code Labs", role: "Lead Co-Instructor", year: "2022 – 2023", tags: %w[ed-tech] }
]

community_tag_map.each do |entry|
  item = CommunityItem.find_by!(title: entry[:title], role: entry[:role], year: entry[:year])
  item.tags = entry[:tags].map { |s| tag_by_slug[s] }.compact
end
