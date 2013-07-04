class Station < ActiveRecord::Base
	has_many :users, as: :level, dependent: :nullify
	has_many :associates ,dependent: :restrict
	has_many :stocks, dependent: :restrict
	belongs_to :territory, validate: true
	has_many :items, through: :stocks

	accepts_nested_attributes_for :users
	attr_accessible :nameStation, :territory_id, :addr1, :addr2, :pincode, :contactDetails

	validate :ensure_territory_exist

	validates :nameStation, presence: true, length: {maximum: 30}, uniqueness: true
	validates :territory_id, presence: true
	validates :addr1, presence: true
	validates	:addr2, presence: true
	validates	:pincode, presence: true, numericality: true, length: {is: 6}
	validates :contactDetails, presence: true

	private

		def ensure_territory_exist
			if Territory.find(self.territory_id).nil?
				errors.add(:territory_id, 'Territory')
				false
			else
				true
			end
		end

end
