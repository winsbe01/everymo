class User < ActiveRecord::Base

	has_many :goals

	validates :username, presence: true, 
							uniqueness: true
	validates :email, presence: true, uniqueness: true
	
	validates_format_of :email,	:with => /@/
end
