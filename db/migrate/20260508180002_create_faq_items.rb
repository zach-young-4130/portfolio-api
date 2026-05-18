class CreateFaqItems < ActiveRecord::Migration[8.0]
  def change
    create_table :faq_items do |t|
      t.string :question, null: false
      t.text :answer, null: false
      t.integer :position
      t.boolean :published, null: false, default: false

      t.timestamps
    end

    add_index :faq_items, :position
    add_index :faq_items, :published
  end
end
