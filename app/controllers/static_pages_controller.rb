class StaticPagesController < ApplicationController
  def home
    if logged_in?
      # ログイン時にだけ表示する情報の取得処理などを書く。
      @rounds = Round.all
    end
  end
end
