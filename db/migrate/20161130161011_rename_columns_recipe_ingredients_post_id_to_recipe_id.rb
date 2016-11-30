class RenameColumnsRecipeIngredientsPostIdToRecipeId < ActiveRecord::Migration
  def change
    rename_column :recipe_ingredients, :post_id, :recipe_id
  end
end
