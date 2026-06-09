require "rails_helper"

RSpec.describe CommunityItem, type: :model do
  describe "validations" do
    it "requires title and description" do
      item = CommunityItem.new
      expect(item).not_to be_valid
      expect(item.errors[:title]).to be_present
      expect(item.errors[:description]).to be_present
    end
  end

  describe ".published" do
    it "returns only published in position order" do
      a = create(:community_item, position: 2)
      b = create(:community_item, position: 1)
      _draft = create(:community_item, published: false)
      expect(CommunityItem.published).to eq([ b, a ])
    end
  end
end
