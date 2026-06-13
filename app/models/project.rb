class Project < ApplicationRecord
  normalizes :title, :tagline, :description, with: ->(v) { v.strip }
  normalizes :highlights, with: ->(v) { v&.strip }

  has_many :project_technologies, -> { order(:position) }, dependent: :destroy
  has_many :technologies, through: :project_technologies
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings

  validates :title, :tagline, :description, :tech_stack, presence: true
  validates :published, inclusion: { in: [ true, false ] }
  validates :featured, inclusion: { in: [ true, false ] }

  scope :published, -> { where(published: true).order(:position) }
  scope :featured, -> { published.where(featured: true) }
  scope :by_tag, ->(slug) { joins(:tags).where(tags: { slug: slug }) }
  scope :by_technology, ->(slug) { joins(:technologies).where(technologies: { slug: slug }) }
  scope :search, ->(query) {
    return all if query.blank?
    # 'simple' config: no stemming, no stop word removal — acronyms like 'IHM' survive intact.
    # :* suffix on each term enables prefix matching — 'ang' matches 'Angular'.
    safe_query = query.split
      .map { |w| w.gsub(/[^a-zA-Z0-9\-]/, "") }
      .reject(&:empty?)
      .map { |w| "#{w}:*" }
      .join(" & ")
    return all if safe_query.blank?
    where(
      <<~SQL,
        (
          setweight(to_tsvector('simple', coalesce(title, '')),      'A') ||
          setweight(to_tsvector('simple', coalesce(tagline, '')),     'A') ||
          setweight(to_tsvector('simple', coalesce(tech_stack, '')),  'B') ||
          setweight(to_tsvector('simple', coalesce(description, '')), 'C')
        ) @@ to_tsquery('simple', ?)
      SQL
      safe_query
    )
  }
end
