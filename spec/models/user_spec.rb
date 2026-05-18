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

    it "requires a password of at least 8 characters" do
      user = build(:user, password: "short")
      expect(user).not_to be_valid
    end
  end

  describe "#authenticate" do
    it "returns the user for the correct password" do
      user = create(:user, password: "password123")
      expect(user.authenticate("password123")).to eq(user)
    end

    it "returns false for the wrong password" do
      user = create(:user, password: "password123")
      expect(user.authenticate("wrong")).to be(false)
    end
  end

  describe "email normalization" do
    it "downcases and strips whitespace" do
      user = create(:user, email: "  Admin@Example.com  ")
      expect(user.email).to eq("admin@example.com")
    end
  end
end
