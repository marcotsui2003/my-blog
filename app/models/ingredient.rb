class Ingredient < ActiveRecord::Base
  has_many :recipe_ingredients
  has_many :recipes, through: :recipe_ingredients
  has_many :users, through: :recipes
  validates_uniqueness_of :name
  validates :quantity, format: { with: /\A\d+\s?\w+\z/,
    message: "a number followed by unit of measurement, e.g. '1 lb'" }
end
