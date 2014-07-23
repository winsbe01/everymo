class Goal < ActiveRecord::Base
  belongs_to :user
  has_many :days
  validates :name, presence: true,
					uniqueness: { scope: :user_id,
									message: "already exists" }
  validates :goal_wordcount, presence: true,
						numericality: { only_integer: true,
										greater_than: 0 }
  validates :current_wordcount, presence: true,
						numericality: { only_integer: true,
										greater_than_or_equal_to: 0 }
										
	# TODO: make sure these validate to >= today (validates_timeliness?)
  validates :start_date, presence: true
  validates :end_date, presence: true
  
end
