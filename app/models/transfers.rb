class Transfers < ActiveRecord::Base
	 attr_accessible :from, :to, :dateOfDispatch, :dateOfReceipt, :comments, :chalanNo
	 belongs_to :station, foreign_key: "from"
	 belongs_to :station, foreign_key: "to"
	 belongs_to :stock

	 validates :from, presence: true
	 validates :to, presence: true
	 validates :dateOfDispatch, presence: true
	 validate :date_is_not_in_future

	private

	 def date_is_not_in_future
      if self.dateOfDispatch > Date.today
        errors.add(:dateOfDispatch, 'cannot be in future')
        false
      else
        true
      end
    end
	 
end
