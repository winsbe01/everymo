class UsersController < ApplicationController

before_filter :save_login_state, :only => [:new, :create]

def new
	@user = User.new
end

def show
	@user = User.find(params[:id])
end

def index
	@users = User.all
end

def create
	@user = User.new(user_params)
	
	if @user.save
		
		#TODO: log the new user in!
	
		redirect_to @user
	else
		render 'new'
	end
end

private
	def user_params
		params.require(:user).permit(:username, :email, :password, :password_confirmation)
	end

end
