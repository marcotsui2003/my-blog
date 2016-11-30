class RenameColumnRepliesPostIdToRecipeId < ActiveRecord::Migration
  def change
    rename_column :replies, :post_id, :recipe_id
  end
end
