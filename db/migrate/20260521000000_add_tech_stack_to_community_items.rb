class AddTechStackToCommunityItems < ActiveRecord::Migration[8.0]
  def change
    add_column :community_items, :tech_stack, :string
  end
end
