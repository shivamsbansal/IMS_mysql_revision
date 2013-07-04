class ChalanNumber < ActiveRecord::Base
  attr_accessible :chalanNo

  validates :chalanNo, length: {maximum: 8}
end
