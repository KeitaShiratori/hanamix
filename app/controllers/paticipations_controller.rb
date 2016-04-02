class PaticipationsController < ApplicationController
  before_action :logged_in_user

  def approve
    @round = Round.find(params[:round_id])
    @user  = User.find(params[:user_id])
    @user.approve @round
  end
  
  def wish
    @round = Round.find(params[:round_id])
    current_user.wish(@round)
  end

  def unwish
    @round = Round.find(params[:id])
    current_user.unwish @round
  end
  

end
