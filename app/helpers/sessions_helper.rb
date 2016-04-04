module SessionsHelper
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) || User.create_guest(session)
  end

  def logged_in?
    !!current_user
  end

  def store_location
    session[:forwarding_url] = request.url if request.get?
  end
  
  # どこのページからリクエストが来たか保存しておく
  def set_request_referrer
    if request.original_url != request.referrer
      @referrer = request.referrer
      session[:request_from] = request.referrer
    end
  end

  # 前の画面に戻る
  def return_back
    if session[:request_from]
      redirect_to session[:request_from] and return true
    else
      redirect_to root_url
    end
  end
end
