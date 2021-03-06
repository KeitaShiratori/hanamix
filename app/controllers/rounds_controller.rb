class RoundsController < ApplicationController
  require 'securerandom'

  APPEAR_IN_URL_BASE = "https://appear.in/hanamix_"

  before_action :set_round, only: [:show, :edit, :update, :destroy, :appear_in]

  # GET /rounds/1
  def show
    @talk = Talk.new :round_id => @round.id
    @user = current_user
    @owner = @round.owner
    @wish_users = @round.wish_users
    @approvals_users = @round.approvals_users
    @balls = @round.balls
    @talk_list = @round.talks.order(:created_at).reverse_order.page(params[:page])
    @hash = Gmaps4rails.build_markers(@balls) do |ball, marker|
      marker.lat ball.latitude
      marker.lng ball.longitude
      marker.infowindow ball.description
      marker.json({marker_title: ball.title, clickable: false})
    end
  end

  # GET /rounds/new
  def new
    @round = Round.new
  end

  # GET /rounds/1/edit
  def edit
  end

  # POST /rounds
  def create
    # ログインしていなかったらホーム画面に戻す
    unless logged_in?
      redirect_to root_url
    end
    
    image_magick = Magick::Image.from_blob(params[:round][:picture].tempfile.read).shift
    image_magick.to_blob
    puts image_magick.orientation
    logger.debug image_magick.orientation
    image_magick = image_magick.auto_orient
    image_magick.strip!
    if image_magick.filesize > 1000000
      puts "1MBより大きい画像"
      logger.debug "1MBより大きい画像"
    end
    image_magick = image_magick.resize_to_fit(300, 169)
    image_magick = image_magick.resize_to_fill(300, 169)
    
    puts image_magick.inspect
    logger.debug image_magick.inspect
    
    Round.new do |r|
      r.title       = round_params[:title]
      r.description = round_params[:description]
      r.start_at    = Time.now
      r.end_at      = Time.now + r_params[:term].to_f * 60 * 60
      r.lat         = r_params[:lat]
      r.lng         = r_params[:lng]
      r.picture     = round_params[:picture]
      r.user_id     = current_user.id
      
      @round = r

      respond_to do |format|
        if @round.save
          # roundが登録成功した場合の処理
          Ball.new do |b|
            b.title       = @round.title
            b.description = @round.description
            b.latitude    = @round.lat
            b.longitude   = @round.lng
            b.round_id    = @round.id
            
            b.save!
          end
          
          Approval.new do |a|
            a.round_id  = @round.id
            a.user_id   = @round.user_id
            a.type      = "Approval"
            
            a.save!
          end

          flash[:success] = I18n.t('rounds_create.pre') + r.title + I18n.t('rounds_create.suf')
          format.html { redirect_to @round}
          format.json { render :show, status: :created, location: @round}
        else
          format.html { render :new }
          format.json { render json: @round.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /rounds/1
  def update
    respond_to do |format|
      if @round.update(round_params)
        format.html { redirect_to @round, notice: 'Round was successfully updated.' }
        format.json { render :show, status: :ok, location: @round }
      else
        format.html { render :edit }
        format.json { render json: @round.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rounds/1
  def destroy
    @round.destroy
    respond_to do |format|
      format.html { redirect_to rounds_url}
      format.json { head :no_content }
    end
  end

  def appear_in
    if @round.appear_in_url.present?
      return
    end

    n = 12
    @round.appear_in_url = APPEAR_IN_URL_BASE + format("%0#{n}d", SecureRandom.random_number(10**n))
    if @round.save
      flash[:success] = I18n.t('rounds.appear_in.success.pre') + @round.title + I18n.t('rounds.appear_in.success.suf')
      redirect_to @round
    else
      flash[:success] = I18n.t('rounds.appear_in.error.pre') + @round.title + I18n.t('rounds.appear_in.error.suf')
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_round
    @round = Round.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def round_params
    params.require(:round).permit(:title, :description, :picture)
  end

  def r_params
    params.require(:r).permit(:term, :lat, :lng)
  end
end
