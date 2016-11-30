class RenameColumnsRecipeIngredientsCategoryIdToIngredientId < ActiveRecord::Migration
  def change
    rename_column :recipe_ingredients, :category_id, :ingredient_id
  end
end
