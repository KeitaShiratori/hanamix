class PaticipationsController < ApplicationController
  before_action :logged_in_user

  def create
    @round = Round.find(params[:round_id])
    current_user.wish(@round)
  end
  
  def approve
    @round = Round.find(params[:round_id])
    @user  = User.find(params[:user_id])
    @user.approve @round
  end
  
  def now
    create
    redirect_to round_path @round
  end
end
