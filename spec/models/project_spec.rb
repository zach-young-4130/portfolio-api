require "rails_helper"

RSpec.describe Project, type: :model do
  describe "validations" do
    it "requires title, tagline, description, tech_stack" do
      project = Project.new
      expect(project).not_to be_valid
      expect(project.errors[:title]).to be_present
      expect(project.errors[:tagline]).to be_present
      expect(project.errors[:description]).to be_present
      expect(project.errors[:tech_stack]).to be_present
    end
  end

  describe "scopes" do
    it ".published returns only published in position order" do
      a = create(:project, published: true, position: 2)
      b = create(:project, published: true, position: 1)
      _draft = create(:project, published: false)
      expect(Project.published).to eq([ b, a ])
    end

    it ".featured returns only published & featured" do
      featured = create(:project, published: true, featured: true)
      _plain = create(:project, published: true, featured: false)
      _draft_featured = create(:project, published: false, featured: true)
      expect(Project.featured).to eq([ featured ])
    end
  end

  describe "normalization" do
    it "strips whitespace on title" do
      project = create(:project, title: "  My Project  ")
      expect(project.title).to eq("My Project")
    end
  end
end
