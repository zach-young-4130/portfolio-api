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
    description: "An AI-powered system for startup founders that pairs a guided methodology, AI agents, and expert services to take a venture from idea to investor-ready — “Not Just Software. A Complete System.” Architected the founder-facing (ESO) and admin dashboards in Rails 8 + Hotwire for real-time UI without a separate JS framework. Engineered Stripe payment integration across retail and scholarship transaction flows, and implemented a light/dark theming system with Tailwind CSS custom properties.",
    highlights: <<~HIGHLIGHTS,
      Architected the founder-facing (ESO) and admin dashboards in Rails 8 + Hotwire — real-time UI with no separate JS framework.
      Engineered Stripe payments across retail and scholarship transaction flows.
      Built a light/dark theming system on Tailwind CSS custom properties.
    HIGHLIGHTS
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
    description: "An e-commerce and inventory platform for high-quality, low-cost heavy-equipment parts. Built the decoupled system from the ground up with a Rails 8 API backend and an Angular frontend, serving a catalog of 500,000+ parts with sub-second search and a complex parts-filtering and quote workflow. Integrated Authorize.net for payment processing across the full purchase and checkout flow.",
    highlights: <<~HIGHLIGHTS,
      Served a catalog of 500,000+ heavy-equipment parts with sub-second search.
      Built the decoupled system from the ground up — Rails 8 API backend with an Angular SPA frontend.
      Integrated Authorize.net across the full purchase and checkout flow.
    HIGHLIGHTS
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
    description: "A seed-delivery tracking application that let farmers manage loads moving from harvester to cart to semi-truck trailer. Designed a ticketing system that generated unique receipt numbers capturing farm, field, and load data at each transfer point, enabling end-to-end traceability of seed and product delivery from the field to the scale or silo.",
    highlights: <<~HIGHLIGHTS,
      Enabled end-to-end seed traceability from harvester to cart to semi-truck trailer.
      Designed a ticketing system generating unique receipts capturing farm, field, and load data at each transfer point.
      Shipped one Angular + Ionic codebase serving both mobile and web on a Rails API.
    HIGHLIGHTS
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
    description: "A digital-citizenship and online-safety education platform — “Empowering Families. Protecting Futures.” — delivering K-12 curriculum and video programming to families, schools, and districts. Re-engineered the core platform to support a growing curriculum ecosystem, built and maintained the video-delivery pipeline for on-demand educational content, and designed integrations with school-district systems to automate enrollment and reporting workflows.",
    highlights: <<~HIGHLIGHTS,
      Re-engineered the core platform to support a growing K-12 curriculum ecosystem.
      Built and maintained the on-demand video-delivery pipeline.
      Designed school-district integrations that automate enrollment and reporting workflows.
    HIGHLIGHTS
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
    description: "A farmer-owned platform for running an entire irrigation operation from a single mobile app — switching flood pumps and center pivots on or off, setting pivot direction and run times, and tracking water depth, fuel levels, and maintenance alerts in real time. Built the operator-facing dashboard across two major versions (v1 → v2), engineering the real-time sensor visualization field teams rely on to manage pumps and pivots spread across large properties. Implemented tiered admin and superadmin access control on the Rails API, giving platform operators scoped management of devices, accounts, and farm data.",
    highlights: <<~HIGHLIGHTS,
      Delivered the operator dashboard across two major versions (v1 → v2).
      Built the real-time sensor visualization for pumps, pivots, water depth, and fuel levels.
      Implemented tiered admin and superadmin access control on the Rails API.
    HIGHLIGHTS
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
    description: "An outdoor-recreation marketplace for booking guided hunts and fishing trips, connecting 10,000+ hunters with 1,000+ verified outfitters. Led the full v2 modernization — migrating the frontend from Angular 4 to 12 and the backend API from .NET Core 2.1 to 3.1 — and engineered a Hapi.js search microservice backed by MongoDB to power discovery across species, locations, and price ranges.",
    highlights: <<~HIGHLIGHTS,
      Led the full v2 modernization — Angular 4 → 12 and the backend API from .NET Core 2.1 → 3.1.
      Engineered a Hapi.js search microservice backed by MongoDB.
      Powered discovery for 10,000+ hunters across 1,000+ verified outfitters.
    HIGHLIGHTS
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
    description: "The web application for CarGo Eats, the food-ordering and delivery service within the CarGo ride-sharing ecosystem. Built the ordering experience with Angular SSR for faster loads and stronger SEO, and integrated multiple microservices to handle menu management, order routing, and live delivery tracking.",
    highlights: <<~HIGHLIGHTS,
      Built the ordering experience with Angular SSR for faster loads and stronger SEO.
      Integrated microservices for menu management, order routing, and live delivery tracking.
    HIGHLIGHTS
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
    description: "A workforce-engagement platform for cohort-based training that connects job seekers, employers, and training providers — “one platform for cohort-based trainings with built-in engagement.” Developed the full application (later rebranded from Careerquo to Upsquad), building an Angular frontend on a Node.js backend and designing the MongoDB data models and API layer behind flexible career profiles and program management.",
    highlights: <<~HIGHLIGHTS,
      Developed the full application, later rebranded from Careerquo to Upsquad.
      Built an Angular frontend on a Node.js backend.
      Designed the MongoDB data models and API layer behind flexible career profiles and program management.
    HIGHLIGHTS
    tech_stack: "Angular, TypeScript, Bootstrap 5, Angular Material, Node.js, Express, MongoDB",
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
    description: "A B2B delivery platform that let businesses request and manage goods pickup and delivery across the CarGo courier network. Built the full-stack Rails application, coordinating multiple microservices to fulfill delivery workflows end-to-end, and designed the service-integration layer for real-time dispatch communication.",
    highlights: <<~HIGHLIGHTS,
      Built the full-stack Rails application for B2B goods pickup and delivery.
      Coordinated multiple microservices to fulfill delivery workflows end-to-end.
      Designed the service-integration layer for real-time dispatch communication.
    HIGHLIGHTS
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
    description: "The e-commerce storefront for Buchheit's, a farm, ranch, home, and pet supply retailer operating since 1934 across 19 Midwest locations. Maintained and incrementally improved the Angular frontend — keeping the shopping experience stable while it communicated with a microservices backend handling the product catalog, multi-store inventory, and checkout.",
    highlights: <<~HIGHLIGHTS,
      Maintained and incrementally improved the Angular storefront for a 19-location retailer.
      Kept the shopping experience stable against a microservices backend handling catalog, multi-store inventory, and checkout.
    HIGHLIGHTS
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
    description: "A mobile-first fintech app that makes buying and accumulating crypto effortless — “Your Accumulation Headquarters,” with features like spare-change Roundup and recurring Autopilot buys. Led frontend engineering for the customer-service and admin/super-admin dashboard in Angular (delivered through Codefi Works), designing tiered admin interfaces that let internal teams manage users, resolve support requests, and perform elevated platform operations.",
    highlights: <<~HIGHLIGHTS,
      Led frontend engineering for the customer-service and admin/super-admin dashboard in Angular.
      Designed tiered admin interfaces for user management, support resolution, and elevated platform operations.
    HIGHLIGHTS
    tech_stack: "Angular, REST API, TypeScript",
    cover_image_url: "/screenshots/hodlit.jpg",
    live_url: "https://hodlit.com",
    repo_url: nil,
    featured: false,
    position: 11,
    published: true,
    project_start: "2018-01-01",
    project_end: "2018-12-01"
  },
  {
    title: "SeedStory",
    tagline: "Seed-to-sale lifecycle tracking for a horticulture e-commerce platform.",
    description: "A horticulture platform built from concept to a functioning e-commerce application, tracing the full life cycle of a plant from seed to a grown plant ready to sell. A well-documented Rails API-only backend models each plant's grow time, substrate, fertilizer, and other nutrients, and records its location historically as it moves between inventory, greenhouse, field, and harvest — preserving the entire timeline. An Angular application handles admin and grow management, while iOS and Android apps built with React Native (delivered with a contractor team in Ukraine) serve the customer-facing storefront.",
    highlights: <<~HIGHLIGHTS,
      Built v1 from concept to a functioning e-commerce application for horticulture.
      Modeled each plant's full life cycle — grow time, substrate, fertilizer, and nutrients — with historical location tracking across inventory, greenhouse, field, and harvest.
      Shipped a documented Rails API-only backend, an Angular admin app, and React Native iOS/Android apps.
    HIGHLIGHTS
    tech_stack: "Rails API, Angular, React Native, PostgreSQL, Stripe",
    cover_image_url: nil,
    live_url: nil,
    repo_url: nil,
    featured: false,
    position: 12,
    published: true,
    project_start: "2024-01-01",
    project_end: "2024-12-01"
  },
  {
    title: "Shiloh Rentals",
    tagline: "Multi-LLC Stripe subscription payments for a property rental platform.",
    description: "A full-stack Rails application for property rentals, built with Hotwire and Hotwire Native to ship a single codebase across web, iOS, and Android — live as a web app, an Android app in the Play Store, and an iOS app in the App Store. Refactored the Stripe payment architecture from a single company LLC handling all transactions to two payment-enabled LLCs billed via subscriptions, with each company managing many properties.",
    highlights: <<~HIGHLIGHTS,
      Refactored the Stripe payment setup from one company LLC to two payment-enabled LLCs on a subscription model.
      Modeled companies that each own many properties, with billing handled per company across both LLCs.
      Shipped from one Hotwire + Hotwire Native codebase to web, Android (Play Store), and iOS (App Store).
    HIGHLIGHTS
    tech_stack: "Ruby on Rails, Hotwire, Hotwire Native, Stripe, PostgreSQL",
    cover_image_url: nil,
    live_url: nil,
    repo_url: nil,
    featured: false,
    position: 13,
    published: true,
    project_start: "2026-02-01",
    project_end: "2026-02-28"
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
  # Languages
  { name: "Ruby",          slug: "ruby",            category: "language"  },
  { name: "TypeScript",    slug: "typescript",      category: "language"  },
  { name: "JavaScript",    slug: "javascript",      category: "language"  },
  { name: "HTML5",         slug: "html5",           category: "language"  },
  { name: "CSS3",          slug: "css3",            category: "language"  },
  # Frameworks
  { name: "Ruby on Rails", slug: "ruby-on-rails",   category: "framework" },
  { name: "Angular",       slug: "angular",         category: "framework" },
  { name: "Hotwire",       slug: "hotwire",         category: "framework" },
  { name: "Hotwire Native", slug: "hotwire-native", category: "framework" },
  { name: "Turbo",         slug: "turbo",           category: "framework" },
  { name: "Stimulus",      slug: "stimulus",        category: "framework" },
  { name: "Ionic",         slug: "ionic",           category: "framework" },
  { name: "React Native",  slug: "react-native",    category: "framework" },
  { name: ".NET Core",     slug: "dotnet-core",     category: "framework" },
  { name: "Hapi.js",       slug: "hapi-js",         category: "framework" },
  { name: "Express",       slug: "express",         category: "framework" },
  # Platforms
  { name: "PostgreSQL",    slug: "postgresql",      category: "platform"  },
  { name: "Redis",         slug: "redis",           category: "platform"  },
  { name: "MongoDB",       slug: "mongodb",         category: "platform"  },
  { name: "Node.js",       slug: "nodejs",          category: "platform"  },
  { name: "Vercel",        slug: "vercel",          category: "platform"  },
  { name: "Fly.io",        slug: "fly-io",          category: "platform"  },
  { name: "AWS",           slug: "aws",             category: "platform"  },
  { name: "Hatchbox",      slug: "hatchbox",        category: "platform"  },
  { name: "DigitalOcean",  slug: "digital-ocean",   category: "platform"  },
  # Tools
  { name: "Sidekiq",       slug: "sidekiq",         category: "tool"      },
  { name: "Stripe",        slug: "stripe",          category: "tool"      },
  { name: "Authorize.net", slug: "authorize-net",   category: "tool"      },
  { name: "Git",           slug: "git",             category: "tool"      },
  { name: "RSpec",         slug: "rspec",           category: "tool"      },
  { name: "REST APIs",     slug: "rest-apis",       category: "tool"      },
  { name: "RuboCop",       slug: "rubocop",         category: "tool"      },
  { name: "Brakeman",      slug: "brakeman",        category: "tool"      },
  { name: "Capybara",      slug: "capybara",        category: "tool"      },
  { name: "FactoryBot",    slug: "factory-bot",     category: "tool"      },
  { name: "Cypress",       slug: "cypress",         category: "tool"      },
  { name: "Jest",          slug: "jest",            category: "tool"      },
  # Libraries
  { name: "Tailwind CSS",  slug: "tailwind-css",    category: "library"   },
  { name: "Bootstrap",     slug: "bootstrap",       category: "library"   },
  # Rails gems (researched common picks — prune as needed)
  { name: "Devise",        slug: "devise",          category: "library"   },
  { name: "Pundit",        slug: "pundit",          category: "library"   },
  { name: "CanCanCan",     slug: "cancancan",       category: "library"   },
  { name: "Pagy",          slug: "pagy",            category: "library"   },
  { name: "Kaminari",      slug: "kaminari",        category: "library"   },
  { name: "Ransack",       slug: "ransack",         category: "library"   },
  { name: "Faker",         slug: "faker",           category: "library"   },
  { name: "Bullet",        slug: "bullet",          category: "library"   },
  { name: "Solid Queue",   slug: "solid-queue",     category: "library"   },
  { name: "Active Admin",  slug: "active-admin",    category: "library"   },
  { name: "GraphQL Ruby",  slug: "graphql-ruby",    category: "library"   },
  { name: "Mobility",      slug: "mobility",        category: "library"   },
  # Angular libraries (researched common picks — prune as needed)
  { name: "RxJS",          slug: "rxjs",            category: "library"   },
  { name: "NgRx",          slug: "ngrx",            category: "library"   },
  { name: "NGXS",          slug: "ngxs",            category: "library"   },
  { name: "Angular Material", slug: "angular-material", category: "library" },
  { name: "Angular CDK",   slug: "angular-cdk",     category: "library"   },
  { name: "PrimeNG",       slug: "primeng",         category: "library"   },
  { name: "NG-ZORRO",      slug: "ng-zorro",        category: "library"   },
  { name: "NG Bootstrap",  slug: "ng-bootstrap",    category: "library"   },
  { name: "ngx-translate", slug: "ngx-translate",   category: "library"   },
  { name: "Transloco",     slug: "transloco",       category: "library"   },
  { name: "ngx-charts",    slug: "ngx-charts",      category: "library"   },
  { name: "AG Grid",       slug: "ag-grid",         category: "library"   },
  { name: "Apollo Angular", slug: "apollo-angular", category: "library"   },
  { name: "ngx-formly",    slug: "ngx-formly",      category: "library"   }
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
  { name: "fin-tech",           slug: "fin-tech" },
  { name: "property-management", slug: "property-management" }
]

tag_by_slug = tags_data.each_with_object({}) do |attrs, map|
  tag = Tag.find_or_initialize_by(slug: attrs[:slug])
  tag.update!(attrs)
  map[attrs[:slug]] = tag
end

Tag.where.not(slug: tag_by_slug.keys).destroy_all

# --- Project associations ----------------------------------------------------

project_tech_map = {
  "Traction Studio AI"  => %w[ruby-on-rails ruby hotwire turbo stimulus postgresql redis sidekiq tailwind-css stripe html5 css3 javascript],
  "IHM Used Parts"      => %w[ruby-on-rails ruby angular typescript postgresql rest-apis authorize-net html5 css3 javascript],
  "SR Harvesting"       => %w[angular typescript ionic ruby-on-rails ruby postgresql rest-apis html5 css3 javascript],
  "Parent ProTech"      => %w[ruby-on-rails ruby angular typescript postgresql rest-apis html5 css3 javascript],
  "PumpTrakr"           => %w[angular typescript ruby-on-rails ruby postgresql rest-apis html5 css3 javascript],
  "Venku"               => %w[angular typescript dotnet-core hapi-js nodejs mongodb html5 css3 javascript],
  "CarGo Eats"          => %w[angular typescript rest-apis html5 css3 javascript],
  "Careerquo / Upsquad" => %w[angular typescript bootstrap angular-material nodejs express mongodb rest-apis html5 css3 javascript],
  "CarGo Courier"       => %w[ruby-on-rails ruby postgresql rest-apis html5 css3 javascript],
  "Buchheit's"          => %w[angular typescript rest-apis html5 css3 javascript],
  "Hodlit"              => %w[angular typescript bootstrap rest-apis html5 css3 javascript],
  "SeedStory"           => %w[ruby-on-rails ruby angular typescript react-native postgresql stripe rest-apis html5 css3 javascript],
  "Shiloh Rentals"      => %w[ruby-on-rails ruby hotwire hotwire-native stripe postgresql html5 css3 javascript]
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
  "Hodlit"              => %w[fin-tech],
  "SeedStory"           => %w[ag-tech e-commerce mobile],
  "Shiloh Rentals"      => %w[property-management fin-tech mobile]
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
