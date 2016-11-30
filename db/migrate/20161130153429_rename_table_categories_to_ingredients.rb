class RenameTableCategoriesToIngredients < ActiveRecord::Migration
  def change
    rename_table :categories, :ingredients
  end
end
