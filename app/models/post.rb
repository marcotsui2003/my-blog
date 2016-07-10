class Post < ActiveRecord::Base
  belongs_to :user
  has_many :post_categories
  has_many :categories, through: :post_categories
  has_many :comments, inverse_of: :post
  has_many :commenters, through: :comments
  has_many :replies, inverse_of: :post

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



end
