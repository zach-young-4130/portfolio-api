FactoryBot.define do
  factory :page_view do
    path       { "/" }
    ip_address { "192.168.1.0" }
    user_agent { "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)" }
    city       { "Cape Girardeau" }
    region     { "Missouri" }
    country    { "United States" }
  end
end
