class AddIndexRepliesRecipeId < ActiveRecord::Migration
  def change
    add_index :replies, :recipe_id
  end
end
