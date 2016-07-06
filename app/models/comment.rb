class Comment < ActiveRecord::Base
  belongs_to :post, inverse_of: :comments
  belongs_to :commenter, class_name: "User", inverse_of: :comments
  has_many :replies, as: :repliable
end
