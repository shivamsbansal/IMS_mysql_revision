class Vendor < ActiveRecord::Base
	belongs_to :category
	has_many :items ,dependent: :nullify

	accepts_nested_attributes_for :items
	attr_accessible :nameVendor, :email, :phone, :category_id
	
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :nameVendor, presence: true, length: { maximum: 50 }
	validates :email, presence: true, format:     { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
	validates :phone, presence: true, length: { is: 10 }, numericality: true
	validate :ensure_category_exist

	private

		def ensure_category_exist
			if self.category_id.nil?
				true
			elsif Category.find(self.category_id).nil?
				errors.add(:category_id, 'not exist')
				false
			else
				true
			end
		end
end
