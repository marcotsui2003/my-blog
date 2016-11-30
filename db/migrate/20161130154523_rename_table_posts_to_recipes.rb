class RenameTablePostsToRecipes < ActiveRecord::Migration
  def change
    rename_table :posts, :recipes
  end
end
