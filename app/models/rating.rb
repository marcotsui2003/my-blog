class Rating < ActiveRecord::Base
  belongs_to :rater, class_name: "User", inverse_of: :ratings
  belongs_to :recipe, inverse_of: :ratings
  validates :grade, numericality: { only_integer: true, less_than_or_equal_to: 10, allow_nil: true }

end
