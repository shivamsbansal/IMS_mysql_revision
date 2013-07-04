class Region < ActiveRecord::Base
	has_many :territories, dependent: :restrict
	has_many :stations, through: :territories
	has_many :users, as: :level, dependent: :nullify

	accepts_nested_attributes_for :territories, :users
	attr_accessible :nameRegion, :idRegion

	validates :idRegion, presence: true, length: {maximum: 10}, uniqueness: true
	validates :nameRegion, presence: true, length: {maximum: 30}, uniqueness: true
end
