class PageView < ApplicationRecord
  # Known bots, crawlers, and AI scrapers — reject before touching the DB.
  BOT_PATTERN = /
    bot|crawl|spider|slurp|archive|fetch|lighthouse|
    GPTBot|ClaudeBot|anthropic|openai|Amazonbot|
    curl|wget|python|ruby|java|go-http|php|axios|
    facebookexternalhit|WhatsApp|Twitterbot|Applebot|
    AhrefsBot|SemrushBot|MajesticBot|DotBot|BLEXBot|
    pingdom|datadog|uptimerobot|statuscake
  /xi

  validates :path, presence: true

  scope :human, -> { where.not(user_agent: nil) }

  def self.bot?(user_agent)
    return true if user_agent.blank?
    user_agent.match?(BOT_PATTERN)
  end
end
