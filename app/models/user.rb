class User < ApplicationRecord
  # Default validations require a password; we manage that ourselves so
  # Google-only users can exist without one.
  has_secure_password validations: false

  normalizes :email, with: ->(email) { email.strip.downcase }

  MAX_FAILED_ATTEMPTS = 5
  LOCKOUT_DURATION = 15.minutes
  ROLES = %w[user admin].freeze

  validates :email,
            presence: true,
            uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 12 }, allow_nil: true
  validates :role, inclusion: { in: ROLES }
  validate  :must_have_auth_method

  scope :admins, -> { where(role: "admin") }

  def admin?
    role == "admin"
  end

  def locked?
    locked_until.present? && locked_until > Time.current
  end

  # Increments the failed-login counter and locks the account once the cap is
  # hit. Uses update_columns to skip validations/callbacks — we never want
  # password validation to fire just because someone got the password wrong.
  def register_failed_attempt!
    new_count = failed_attempts + 1
    if new_count >= MAX_FAILED_ATTEMPTS
      update_columns(failed_attempts: new_count, locked_until: LOCKOUT_DURATION.from_now)
    else
      update_columns(failed_attempts: new_count)
    end
  end

  def reset_failed_attempts!
    return if failed_attempts.zero? && locked_until.nil?
    update_columns(failed_attempts: 0, locked_until: nil)
  end

  private

  # A user must have at least one way to authenticate — a password or a
  # linked Google account. Prevents creating "ghost" users with neither.
  def must_have_auth_method
    return if password_digest.present? || google_uid.present?
    errors.add(:base, "must have a password or a linked Google account")
  end
end
