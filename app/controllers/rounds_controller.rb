class RoundsController < ApplicationController
  before_action :set_round, only: [:show, :edit, :update, :destroy, :score, :battle]

  # GET /rounds
  # GET /rounds.json
  def index
    @rounds = Round.all
  end

  # GET /rounds/1
  # GET /rounds/1.json
  def show
    if logged_in?
      @user = current_user
      @balls = @round.balls
      @hash = Gmaps4rails.build_markers(@balls) do |ball, marker|
        marker.lat ball.latitude
        marker.lng ball.longitude
        marker.infowindow ball.description
        marker.json({marker_title: ball.title, clickable: false})
      end
    else
      redirect_to root_url
    end
  end

  # GET /rounds/new
  def new
    @round = Round.new

    @balls = @round.balls
    @hash = Gmaps4rails.build_markers(@balls) do |ball, marker|
      marker.lat ball.latitude
      marker.lng ball.longitude
      marker.infowindow ball.description
      marker.json({title: ball.title})
    end
  end

  # GET /rounds/1/edit
  def edit
  end

  # POST /rounds
  # POST /rounds.json
  def create
    # TODO リクエスト不正（ballsが存在しないとき）のエラー判定処理を最初に行う。
    
    @round = Round.new(round_params)

    respond_to do |format|
      if @round.save
        # roundが登録成功した場合の処理
        create_balls
        flash[:info] = I18n.t('rounds_create.pre') + @round.title + I18n.t('rounds_create.suf')
        format.html { redirect_to @round}
        format.json { render :show, status: :created, location: @round }
      else
        format.html { render :new }
        format.json { render json: @round.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rounds/1
  # PATCH/PUT /rounds/1.json
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
  # DELETE /rounds/1.json
  def destroy
    @round.destroy
    respond_to do |format|
      format.html { redirect_to rounds_url}
      format.json { head :no_content }
    end
  end
  
  def score
    # パラメータを取得
    # ボールの座標と現在地の座標が既定の範囲内にあるか判定
    # OKなら、ボールをゲット扱いにするため、ボールの所有者を登録する。
    req = score_req
    lat = req[:lat].to_f
    lng = req[:lng].to_f
    user_id = req[:user_id].to_i
    ret = {balls: [], has_new_ball: false, has_all_ball: false}
    ret[:balls] = User.find(user_id).balls.where(round_id: @round.id).pluck(:title) # すでに自分が所有しているボールをretにセット

    @balls = @round.balls
    
    @balls.each do |b|
      next if b.has_owner # すでに所有者がいたらバトルしないとゲットできない

      distance = b.distance lat, lng
      puts "#{b.title}: #{distance}"
      if distance < 1.0e-08
        puts "#{b.title} get!!"
        b.owner user_id
        ret[:balls].push b.title
        ret[:has_new_ball] = true
      end
    end

    has_all_ball = ret.length >= 7 ? true : false

    respond_to do |format|
      # フォーマットがjsの時の処理。
      # @statusに”success”を代入してjsファイルに渡している。
      format.js { @status = "success", @ret = ret }
    end
  end
  
  def battle
    # パラメータを取得
    # 攻撃側ユーザと防御側ユーザの現在地座標が既定の範囲内にあるか判定
    # OKなら、攻撃側の攻撃力と防御側の防御力を計算
    # 攻撃成功なら、ボールの所有者を攻撃者に変更する。
    # 
    
    # TODO DemoDay用に、ボールゲットのアニメーションを必ず実行できるようにした。あとで削除
    ret = {balls: [], has_new_ball: false, has_all_ball: false}
    ret[:balls] = @round.balls.pluck(:title)
    ret[:has_new_ball] = true
    respond_to do |format|
      format.js { @status = "success", @ret = ret }
    end
  end
  
private
  # Use callbacks to share common setup or constraints between actions.
  def set_round
    @round = Round.find(params[:id])
  end

  def create_req
    params.require(:round).permit(:title, :description, :start_at, :end_at, :picture, :balls)
  end
  
  def score_req
    params.permit(:lat, :lng, :user_id, :id)
  end
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def round_params
    params.require(:round).permit(:title, :description, :start_at, :end_at)
  end
  
  def create_balls
    balls = create_req[:balls]
    balls_array = balls.split(",")

    for i in 1..7
      Ball.new do |b|
        b.title       = balls_array[i * 4 - 4]
        b.description = balls_array[i * 4 - 3]
        b.latitude    = balls_array[i * 4 - 2]
        b.longitude   = balls_array[i * 4 - 1]
        b.round_id    = @round.id
        
        b.save!
      end
    end
  end
  
end
