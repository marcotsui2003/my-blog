class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :grade
      t.integer :rater_id, index: true
      t.integer :recipe_id, index: true
      t.timestamps null: false
    end
  end
end
