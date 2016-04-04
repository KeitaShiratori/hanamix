class SessionsController < ApplicationController
  def new
    set_request_referrer
  end
  
  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      session[:user_id] = @user.id
      flash[:success] =  I18n.t('sessions_create.log_in_as.pre') + @user.name + I18n.t('sessions_create.log_in_as.suf')
      # redirect_to root_url
      return_back
    else
      flash[:danger] = 'invalid email/password combination'
      render 'new'
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
