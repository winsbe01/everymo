class GoalsController < ApplicationController

def new
	@user = User.find(params[:user_id])
	@goal = Goal.new
end

def update
	@user = User.find(params[:user_id])
	@goal = Goal.find(params[:id])
	
	if is_active?(@goal)
	
		# updates the current_wordcount of the goal
		@goal.update(goal_params)

		@day = Day.where("goal_id = ? AND date = ?", @goal.id, Date.today).first
		
		if @day.nil?
			#@day = create_day(@goal, Date.today)
			#if not @day.valid?
				
			# TODO: render some sort of error here. this should never happen
			raise "no Day available!"
			
			#end
		else
			# update the current day's wordcount
			update_day(@day, @goal.current_wordcount)
			
			# update the wordcount for every date in the future of the goal
			(@day.date..@goal.end_date).each {
				|future_date|
				new_day = Day.where("goal_id = ? AND date = ?", @goal.id, future_date).first
				update_day(new_day, @goal.current_wordcount)
			}
			
			#update_current_wordcount(@goal, @day, @goal.current_wordcount)
		end
		
	end
	
	redirect_to user_goal_path(@user,@goal)
end

def show
	@user = User.find(params[:user_id])
	@goal = Goal.find(params[:id])
	@days = Day.where("goal_id = ?", @goal.id)
	
	@day_labels = []
	@day_data = []
	@day_par = []
	
	wpd = @goal.goal_wordcount / (@goal.end_date - @goal.start_date + 1)
	
	# calculation: current_wordcount + 
	#(current_wordcount - total_wordcount) + 
	#(par_wordcount - current_wordcount)
	
	count = 0
	
	@days.each do |u|
	
		# add the date label
		@day_labels[count] = u.date.strftime('%Y-%m-%d')
		
		# add the the wordcount, if it's today or earlier
		# else add zero
		if u.date > Date.today
			@day_data[count] = 0
		else
			@day_data[count] = u.wordcount
		end
		
		# calculation: day# * number of words per day
		@day_par[count] = ((count + 1) * wpd).floor
		
		# get the current par value
		if u.date = Date.today
			cur_day = count
		end
			
		count += 1
	end
	
	@cur_par = @day_par[@day_labels.index(Date.today.strftime('%Y-%m-%d'))]
end

def destroy
	# get the user and goal, destroy the goal
	@user = User.find(params[:user_id])
	@goal = Goal.find(params[:id])
	
	# TODO: figure out if i need to delete the dependent resources
	@goal.destroy
	
	redirect_to user_path(@user)
end

def create
	# get the current user, create a goal beneath them
	@user = User.find(params[:user_id])
	@goal = @user.goals.create(goal_params)
	
	if @goal.valid?
		# create all the days between start_date and end_date
		(@goal.start_date..@goal.end_date).each {
			|current_date|
			create_day(@goal, current_date)
		}
		
		# show the user page
		redirect_to user_path(@user)
	else
		# render new again, should show errors
		render 'new'
	end
end

def update_current_wordcount(goal, day, wordcount)
	# update the goal's current wordcount
	goal.update(:current_wordcount => wordcount)
	
	# update every day's wordcount from today forward
	(Date.today..goal.end_date).each {
		|future_date|
		new_day = Day.where("goal_id = ? AND date = ?", goal.id, future_date).first
		update_day(new_day, @goal.current_wordcount)
	}
end

private
	def goal_params
		params.require(:goal).permit(:name, :current_wordcount,
										:goal_wordcount,
										:start_date,
										:end_date)
	end
	
	def is_active?(goal)
		if Date.today >= goal.start_date and Date.today <= goal.end_date
			true
		else
			false
		end
	end
	
	def create_day(goal, date)
		return goal.days.create(date: date, wordcount: goal_params[:current_wordcount])
	end
	
	def update_day(day, wordcount)
		day.update(:wordcount => wordcount)
	end
end