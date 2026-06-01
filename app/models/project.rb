class Project < ApplicationRecord
  normalizes :title, :tagline, :description, with: ->(v) { v.strip }

  has_many :project_technologies, -> { order(:position) }, dependent: :destroy
  has_many :technologies, through: :project_technologies
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings

  validates :title, :tagline, :description, :tech_stack, presence: true
  validates :published, inclusion: { in: [true, false] }
  validates :featured, inclusion: { in: [true, false] }

  scope :published, -> { where(published: true).order(:position) }
  scope :featured, -> { published.where(featured: true) }
  scope :by_tag, ->(slug) { joins(:tags).where(tags: { slug: slug }) }
  scope :by_technology, ->(slug) { joins(:technologies).where(technologies: { slug: slug }) }
end
