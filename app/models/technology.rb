class Technology < ApplicationRecord
  CATEGORIES = %w[language framework tool platform library].freeze

  normalizes :name, with: ->(v) { v.strip }
  normalizes :slug, with: ->(v) { v.strip.downcase.gsub(/\s+/, "-") }

  has_many :project_technologies, dependent: :destroy
  has_many :projects, through: :project_technologies

  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9-]+\z/ }
  validates :category, inclusion: { in: CATEGORIES }, allow_nil: true

  scope :ordered, -> { order(:name) }
end
