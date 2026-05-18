class CommunityItem < ApplicationRecord
  normalizes :title, :description, with: ->(v) { v.strip }

  validates :title, :description, presence: true
  validates :published, inclusion: { in: [true, false] }

  scope :published, -> { where(published: true).order(:position) }
end
