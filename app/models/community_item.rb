class CommunityItem < ApplicationRecord
  normalizes :title, :description, with: ->(v) { v.strip }

  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings

  validates :title, :description, presence: true
  validates :published, inclusion: { in: [true, false] }

  scope :published, -> { where(published: true).order(:position) }
end
