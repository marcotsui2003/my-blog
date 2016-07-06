class Reply < ActiveRecord::Base
  belongs_to :repliable, polymorphic: true
  has_many :replies, as: :repliable
  belongs_to :replier, class_name: "User", inverse_of: :replies
end
