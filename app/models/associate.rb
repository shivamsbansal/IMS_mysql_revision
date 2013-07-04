class Associate < ActiveRecord::Base
  belongs_to :station
  before_save { self.email = email.downcase }
  has_many :issued_items, dependent: :delete_all
  has_many :issued_consumables, dependent: :delete_all
  has_many :assets, through: :issued_items

  accepts_nested_attributes_for :issued_items, :issued_consumables
  before_save { self.email = email.downcase }
  attr_accessible :name, :email, :dateOfJoining, :station_id 

  validate :ensure_station_exist
  validates :name , presence: true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :dateOfJoining, presence: {:message => 'is Bank/invalid'}
  validates :station_id, presence: true	
  validate :date_is_not_in_future

  private

   def ensure_station_exist
      if Station.find(self.station_id).nil?
        errors.add(:station_id, 'Station does not exist')
        false
      else
        true
      end
    end

  def date_is_not_in_future
    if self.dateOfJoining > Date.today
      errors.add(:dateOfJoining, 'cannot be in future')
      false
    else
      true
    end
  end
end
