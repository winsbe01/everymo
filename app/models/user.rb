require 'bcrypt'

class User < ActiveRecord::Base

	EMAIL_REGEX = /@/

	has_many :goals

	validates :username, presence: true, 
							uniqueness: true
	validates :email, presence: true, uniqueness: true
	validates_format_of :email,	:with => EMAIL_REGEX
	validates :password, :confirmation => true
	validates_length_of :password, :in => 6..20, :on => :create
	
	attr_accessor :password
	
	before_save :encrypt_password
	after_save :clear_password
	
	def encrypt_password
		if password.present?
			self.salt = BCrypt::Engine.generate_salt
			self.encrypted_password = BCrypt::Engine.hash_secret(password, salt)
		end
	end
	
	def clear_password
		self.password = nil
	end
	
	def self.authenticate(username_or_email="", login_password="")
		if EMAIL_REGEX.match(username_or_email)
			user = User.find_by_email(username_or_email)
		else
			user = User.find_by_username(username_or_email)
		end
		
		if user && user.match_password(login_password)
			return user
		else
			return false
		end
	end
	
	def match_password(login_password="")
		encrypted_password == BCrypt::Engine.hash_secret(login_password, salt)
	end
end
