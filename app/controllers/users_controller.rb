class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :microposts, :feed, :update, :destroy]
  
  def show
    if logged_in?
      set_user
    else
      redirect_to root_url
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:info] =  I18n.t('users_create.log_in_as.pre') + @user.name + I18n.t('users_create.log_in_as.suf')
      session[:user_id] = @user.id
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = set_user
    if current_user != @user
      flash.now[:danger] = '不正なページ遷移を検出しました'
      redirect_to root_url
    end
  end

  def update
    if !check_old_pwd
      flash.now[:danger] = 'パスワードが一致しません'
      return render 'edit'
    end
    
    profile = user_profile
    profile.delete(:old_password)

    if @user.update(profile)
      # 保存に成功した場合はトップページへリダイレクト
      flash.now[:info] = 'メッセージを編集しました'
      redirect_to @user
    else
      # 保存に失敗した場合は編集画面へ戻す
      flash.now[:danger] = 'この内容は登録できません'
      render 'edit'
    end
  end

private

  # get parameters for sinup
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
    
  # get parameters for profile editing
  def user_profile
    params.require(:user).permit(:name, :email, :description, :location, :password, :password_confirmation, :old_password)
  end
  
  def check_old_pwd
    if u = params[:user]
      old_pwd = u[:old_password]
      new_pwd = u[:password]
      confirm = u[:password_confirmation]
      return true if old_pwd.blank? && new_pwd.blank? && confirm.blank?
      return false unless old_pwd.presence && new_pwd.presence && confirm.presence
      !!@user.authenticate(old_pwd) 
    else
      false # 通常はここには来ないけど安全策
    end
  end
 
  def set_user
    @user=User.find(params[:id])
  end
end
