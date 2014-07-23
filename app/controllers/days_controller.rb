class DaysController < ApplicationController

def update
	@goal = Goal.find(params[:goal_id])
	@user = User.find(@goal.user_id)
	@day = Day.find(params[:id])
	
	if @day.valid? and @day.date <= Date.today
		@day.update(day_params)
		
		if @day.date == Date.today
		
			# update the current wordcount
			@goal.update(:current_wordcount => @day.wordcount)
			
			# update today's date and all future dates
			(Date.today..@goal.end_date).each {
				|future_date|
				new_day = Day.where("goal_id = ? AND date = ?", @goal.id, future_date).first
				new_day.update(:wordcount => @goal.current_wordcount)
			}
		end
	end
	
	redirect_to user_goal_path(@user, @goal)
end

def index
	@user = User.find(params[:user_id])
	@goal = Goal.find(params[:goal_id])
	@days = Day.where("goal_id = ? AND date <= ?", params[:goal_id], Date.today).all
end

def create
	puts "creating a day"
end

#def create
#	@user = User.find(params[:user_id])
#	@goal = Goal.find(params[:goal_id])
#	@day = @goal.days.create(day_params)
#	
#	if @day.valid?
#		redirect_to user_goal_path(@user,@goal)
#	else
#		render 'new'
#	end
#end

private
	def day_params
		params.require(:day).permit(:date, :wordcount)
	end
end
