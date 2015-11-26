class Round < ActiveRecord::Base
  # バリデーション定義
  validates :title, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 500 }

  # リレーション定義
  has_many :balls, dependent: :destroy
  
  # 画像アップローダー
  mount_uploader :picture, PictureUploader
end
