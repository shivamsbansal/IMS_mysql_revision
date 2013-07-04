class User < ActiveRecord::Base
	belongs_to :level, polymorphic: true 
  before_save { self.email = email.downcase }
  before_save :create_remember_token

  attr_accessible :name, :email, :phone, :level_id, :level_type, :password, :password_confirmation
  attr_accessible :admin , :as => :admin

  attr_accessor :is_admin_applying_update

  validate :ensure_level_exist
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true, format:     { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  has_secure_password
  validates :phone, presence: true, length: { is: 10 }, numericality: true
  validates :password_confirmation, presence: true, :unless => :is_admin_applying_update
  validates :password, presence: true, length: { minimum: 6 }, :unless => :is_admin_applying_update


  private
  	def create_remember_token
  		self.remember_token = SecureRandom.urlsafe_base64
  	end

    def ensure_level_exist
      if self.level_id.nil? || self.level_type == 'admin'
        true
      elsif self.level_type.constantize.find(self.level_id).nil?
        errors.add(:level_id, 'Level does not exist')
        false
      else
        true
      end
    end

end