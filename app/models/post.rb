class Post < ActiveRecord::Base
  belongs_to :user
  has_many :post_categories
  has_many :categories, through: :post_categories
  has_many :comments, inverse_of: :post
  has_many :commenters, through: :comments
  has_many :replies, inverse_of: :post

  accepts_nested_attributes_for :categories

  def self.pick_blogger(user_id)
    if user_id.blank?
      self.all
    else
      where("posts.user_id = ?" , user_id )
    end
  end

  def self.by_category(category_id)
    if category_id.blank?
      self.all
    else
      joins(:categories).where("categories.id = ?", category_id)
    end
  end

  def self.by_date(date)
    if date.blank?
      self.all
    elsif date == "This week"
      where("posts.created_at >= ?", Time.zone.now - 7.days)
    elsif date == "Today"
      where("posts.created_at >= ?", Time.zone.today.beginning_of_day)
    elsif date =="Older posts"
      where("posts.created_at < ?", Time.zone.now - 7.days)
    end
  end

  def categories_attributes=(category_attributes)
    category_attributes.values.each do |category_name|
      category = Category.find_or_create_by(category_name)
      self.categories << category
      #below wont work coz @post has not been saved:
      #self.categories << category unless self.categories.exists?(category)
      #use category_ids = category_ids.uniq after save..
    end
    unique_category_ids = self.category_ids.uniq
    self.categories.clear
    self.category_ids = unique_category_ids
  end

end
