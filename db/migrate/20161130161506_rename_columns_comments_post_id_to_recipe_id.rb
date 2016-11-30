class RenameColumnsCommentsPostIdToRecipeId < ActiveRecord::Migration
  def change
    rename_column :comments, :post_id, :recipe_id
  end
end
