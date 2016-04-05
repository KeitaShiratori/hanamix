class TalksController < ApplicationController
  before_action :logged_in_user, only: [:create]

  def create
    @talk = current_user.talks.build(talk_params)
    if @talk.save
      flash[:success] = "投稿しました"
    else
      flash[:danger] = '投稿できませんでした'
    end
    @round = Round.find(@talk.round_id)
    @talk_list = @round.talks.order(:created_at).reverse_order.page(params[:page])
    @talk  = Talk.new :round_id => @round.id
  end

  private
  def talk_params
    params.require(:talk).permit(:content, :round_id)
  end
end
