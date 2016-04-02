class TalksController < ApplicationController
  before_action :logged_in_user, only: [:create]

  def create
    @talk = current_user.talks.build(talk_params)
    if @talk.save
      flash[:success] = "投稿しました"
      @round = Round.find(@talk.round_id)
      @talk_list = @round.talks.order(:created_at).reverse_order
      @talk  = Talk.new :round_id => @round.id
    else
      flash[:danger] = '投稿できませんでした'
    end
    # redirect_to request.referrer
  end

  def destroy
    @talk = current_user.talks.find_by(id: params[:id])
    return redirect_to root_url if @talk.nil?
    @talk.destroy
    flash[:success] = "talk deleted"
    redirect_to request.referrer || root_url
  end
  
  private
  def talk_params
    params.require(:talk).permit(:content, :round_id)
  end
end
