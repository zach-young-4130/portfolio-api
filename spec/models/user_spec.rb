require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it "requires an email" do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
    end

    it "requires a unique email (case-insensitive)" do
      create(:user, email: "Admin@Example.com")
      duplicate = build(:user, email: "admin@example.com")
      expect(duplicate).not_to be_valid
    end

    it "rejects invalid email format" do
      user = build(:user, email: "not-an-email")
      expect(user).not_to be_valid
    end

    it "requires a password of at least 12 characters" do
      user = build(:user, password: "short")
      expect(user).not_to be_valid
    end
  end

  describe "#authenticate" do
    it "returns the user for the correct password" do
      user = create(:user, password: "password1234")
      expect(user.authenticate("password1234")).to eq(user)
    end

    it "returns false for the wrong password" do
      user = create(:user, password: "password1234")
      expect(user.authenticate("wrong")).to be(false)
    end
  end

  describe "email normalization" do
    it "downcases and strips whitespace" do
      user = create(:user, email: "  Admin@Example.com  ")
      expect(user.email).to eq("admin@example.com")
    end
  end

  describe "lockout" do
    it "is not locked by default" do
      expect(create(:user)).not_to be_locked
    end

    it "locks after MAX_FAILED_ATTEMPTS register_failed_attempt! calls" do
      user = create(:user)
      User::MAX_FAILED_ATTEMPTS.times { user.register_failed_attempt! }
      expect(user.reload).to be_locked
      expect(user.locked_until).to be > Time.current
    end

    it "is not locked after fewer than MAX_FAILED_ATTEMPTS" do
      user = create(:user)
      (User::MAX_FAILED_ATTEMPTS - 1).times { user.register_failed_attempt! }
      expect(user.reload).not_to be_locked
    end

    it "reset_failed_attempts! clears counter and lock" do
      user = create(:user)
      User::MAX_FAILED_ATTEMPTS.times { user.register_failed_attempt! }
      user.reset_failed_attempts!
      expect(user.reload.failed_attempts).to eq(0)
      expect(user.locked_until).to be_nil
    end
  end
end
