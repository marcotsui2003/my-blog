class AddColumnQuantityToIngredients < ActiveRecord::Migration
  def change
    add_column :ingredients, :quantity, :string, null: false, default: "0"
  end
end
