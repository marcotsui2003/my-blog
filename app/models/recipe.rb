class Recipe < ActiveRecord::Base
  belongs_to :user
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients
  has_many :comments, inverse_of: :recipe, dependent: :destroy
  has_many :commenters, through: :comments
  has_many :replies, inverse_of: :recipe, dependent: :destroy
  accepts_nested_attributes_for :ingredients

  validates_presence_of :title, :content
  validates_uniqueness_of :title, scope: :user

  def self.pick_blogger(user_id)
    if user_id.blank?
      self.all
    else
      where("recipes.user_id = ?" , user_id )
    end
  end

  def self.by_ingredient(ingredient_id)
    if ingredient_id.blank?
      self.all
    else
      joins(:ingredients).where("ingredients.id = ?", ingredient_id)
    end
  end

  def self.by_date(date)
    if date.blank?
      self.all
    elsif date == "This week"
      where("recipes.created_at >= ?", Time.zone.now - 7.days)
    elsif date == "Today"
      where("recipes.created_at >= ?", Time.zone.today.beginning_of_day)
    elsif date =="Older recipes"
      where("recipes.created_at < ?", Time.zone.now - 7.days)
    end
  end

  def ingredients_attributes=(ingredient_attributes)
    index = ingredient_attributes.values.map do |ingredient_name|
      #reject_if to remove blank not working, maybe coz using
      #custom ingredients_attributes method...
      next if ingredient_name['name'].blank?
      Category.find_or_create_by(ingredient_name).id
      #below wont work coz @recipe has not been saved:
      #self.ingredients << ingredient unless self.ingredients.exists?(ingredient)
      #use ingredient_ids = ingredient_ids.uniq after save..
    end
    unique_ingredient_ids = index.uniq
    self.ingredients.clear
    self.ingredient_ids = unique_ingredient_ids
  end

end

=begin
create_table "recipes", force: :cascade do |t|
  t.integer  "user_id"
  t.string   "title"
  t.text     "content"
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
end
=end
