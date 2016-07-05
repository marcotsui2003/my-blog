class Post < ActiveRecord::Base
  belongs_to :user
  has_many :post_categories
  has_many :categories, through: :post_categories
  has_many :comments, inverse_of: :post
  has_many :commenters, through: :comments
end
