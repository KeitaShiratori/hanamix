class StaticPagesController < ApplicationController
  def home
    if logged_in?
      # ログイン時にだけ表示する情報の取得処理などを書く。
      @rounds = Round.all.order(:end_at).reverse_order.page(params[:page])
      if !current_user.guest?
        @new_wish = current_user.owned_rounds_wishes.where('end_at > ?', Time.now.to_s(:db)).first
      end
    end
  end
end
