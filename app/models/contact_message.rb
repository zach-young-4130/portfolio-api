class ContactMessage < ApplicationRecord
  normalizes :name, :message, with: ->(v) { v.strip }
  normalizes :email, with: ->(v) { v.strip.downcase }

  validates :name, :message, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  scope :unread, -> { where(read_at: nil).order(created_at: :desc) }
end
