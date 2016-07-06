class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.references :repliable, polymorphic: true, index: true
      t.text :content
      t.references :replier, index: true
      t.timestamps null: false
    end
  end
end
