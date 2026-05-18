class Project < ApplicationRecord
  normalizes :title, :tagline, :description, with: ->(v) { v.strip }

  validates :title, :tagline, :description, :tech_stack, presence: true
  validates :published, inclusion: { in: [true, false] }
  validates :featured, inclusion: { in: [true, false] }

  scope :published, -> { where(published: true).order(:position) }
  scope :featured, -> { published.where(featured: true) }
end
