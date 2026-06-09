require "rails_helper"

RSpec.describe FaqItem, type: :model do
  describe "validations" do
    it "requires question and answer" do
      item = FaqItem.new
      expect(item).not_to be_valid
      expect(item.errors[:question]).to be_present
      expect(item.errors[:answer]).to be_present
    end
  end

  describe ".published" do
    it "returns only published in position order" do
      a = create(:faq_item, position: 2)
      b = create(:faq_item, position: 1)
      _draft = create(:faq_item, published: false)
      expect(FaqItem.published).to eq([ b, a ])
    end
  end
end
