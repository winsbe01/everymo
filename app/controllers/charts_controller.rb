class ChartsController < ApplicationController

def index
	render json: Day.group(:goal_id)
end

end