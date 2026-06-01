class Tag < ApplicationRecord
  normalizes :name, with: ->(v) { v.strip.downcase }
  normalizes :slug, with: ->(v) { v.strip.downcase.gsub(/\s+/, "-") }

  has_many :taggings, dependent: :destroy
  has_many :projects, through: :taggings, source: :taggable, source_type: "Project"
  has_many :community_items, through: :taggings, source: :taggable, source_type: "CommunityItem"

  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9-]+\z/ }

  scope :ordered, -> { order(:name) }
end
