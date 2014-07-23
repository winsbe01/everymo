class Day < ActiveRecord::Base
  belongs_to :goal
  
  validates :date, presence: true, uniqueness: { scope: :goal_id,
											message: "already has a value" }
end
