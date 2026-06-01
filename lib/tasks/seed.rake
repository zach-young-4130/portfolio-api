namespace :seed do
  desc "Seed all portfolio content (idempotent — safe to re-run)"
  task all: :environment do
    load Rails.root.join("db/seeds.rb")
  end
end
