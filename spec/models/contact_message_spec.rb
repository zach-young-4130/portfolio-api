require "rails_helper"

RSpec.describe ContactMessage, type: :model do
  describe "validations" do
    it "requires name, email, and message" do
      message = ContactMessage.new
      expect(message).not_to be_valid
      expect(message.errors[:name]).to be_present
      expect(message.errors[:email]).to be_present
      expect(message.errors[:message]).to be_present
    end

    it "rejects invalid email format" do
      message = build(:contact_message, email: "not-an-email")
      expect(message).not_to be_valid
    end
  end

  describe "normalization" do
    it "downcases and strips email" do
      message = create(:contact_message, email: "  Hi@Example.com  ")
      expect(message.email).to eq("hi@example.com")
    end
  end

  describe ".unread" do
    it "returns messages with no read_at, newest first" do
      old = create(:contact_message, created_at: 2.days.ago)
      new_msg = create(:contact_message, created_at: 1.hour.ago)
      _read_msg = create(:contact_message, read_at: 1.minute.ago)
      expect(ContactMessage.unread).to eq([ new_msg, old ])
    end
  end
end
