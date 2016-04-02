class Ball < ActiveRecord::Base
  # バリデーション定義
  validates :round_id, presence: true

  # リレーション定義
  belongs_to :round
  belongs_to :user
  
  geocoded_by :address
  after_validation :geocode
  
  # モデルメソッド定義
end
