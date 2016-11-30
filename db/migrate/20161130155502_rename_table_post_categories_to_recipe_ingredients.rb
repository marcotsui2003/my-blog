class RenameTablePostCategoriesToRecipeIngredients < ActiveRecord::Migration
  def change
    rename_table :post_categories, :recipe_ingredients
  end
end
