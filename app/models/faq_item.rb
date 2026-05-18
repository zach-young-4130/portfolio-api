class FaqItem < ApplicationRecord
  normalizes :question, :answer, with: ->(v) { v.strip }

  validates :question, :answer, presence: true
  validates :published, inclusion: { in: [true, false] }

  scope :published, -> { where(published: true).order(:position) }
end
