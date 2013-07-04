class IssuedItem < ActiveRecord::Base
   belongs_to :associate
   belongs_to :asset

   attr_accessible :asset_id, :associate_id, :dateOfIssue
   
   validates :associate_id, presence: true
   validates :asset_id, presence: true
   validates :dateOfIssue, presence: true
   validate :ensure_associate_exist
   validate :ensure_asset_exist
   validate :date_is_not_in_future

   private

   	def ensure_associate_exist
      if Associate.find(self.associate_id).nil?
        errors.add(:associate_id, 'Associate does not exist')
        false
      else
        true
      end
    end

    def ensure_asset_exist
      if Asset.find(self.asset_id).nil?
        errors.add(:asset_id, 'Asset does not exist')
        false
      else
        true
      end
    end

    def date_is_not_in_future
      if self.dateOfIssue > Date.today
        errors.add(:dateOfIssue, 'cannot be in future')
        false
      else
        true
      end
    end

end
