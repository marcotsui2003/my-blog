class Comment < ActiveRecord::Base
  belongs_to :recipe, inverse_of: :comments
  belongs_to :commenter, class_name: "User", inverse_of: :comments
  has_many :replies, as: :repliable, dependent: :destroy

  validates_presence_of :content
end
