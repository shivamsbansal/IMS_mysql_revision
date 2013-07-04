class Item < ActiveRecord::Base
	belongs_to :category
	belongs_to :vendor, validate: true
	has_many :stocks, dependent: :restrict

	attr_accessible :codeItem, :nameItem, :lifeCycle, :leadTime, :vendor_id, :minimumStock, :cost, :assetType, :category_id, :brand, :distinction, :model

	validate :ensure_vendor_exist
	validate :ensure_category_exist
	
	validates :codeItem, presence: true, length: { maximum: 10 }, uniqueness: true
	validates :nameItem, presence: true, length: { maximum: 50 }, uniqueness: true
	validates :cost , presence:true ,numericality: true
	validates :lifeCycle, presence: true, numericality: true
	validates :leadTime, presence: true, numericality: true
	validates :minimumStock, presence: true, numericality: true
	validates :assetType, presence: true, length: { maximum: 15 }
	validates :category_id, presence: true
	validates :brand, presence: true, length: { maximum: 50 }
	validates :distinction, length: { maximum: 50 }
	validates :model, length: { maximum: 50}

	
	private

		def ensure_vendor_exist
			if self.vendor_id.nil?
				true
			elsif Vendor.find(self.vendor_id).nil?
				errors.add(:vendor_id, 'not exist')
				false
			else
				true
			end
		end

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
