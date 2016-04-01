class Round < ActiveRecord::Base
  # バリデーション定義
  validates :title, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 500 }

  # リレーション定義
  has_many :balls, dependent: :destroy
  has_many :talks, dependent: :destroy

  has_many :paticipations, dependent: :destroy
  has_many :paticipate_users, through: :paticipations, source: :user
  
  has_many :wishes, class_name: "Wish", foreign_key: "round_id", dependent: :destroy
  has_many :wish_users , through: :wishes, source: :user

  has_many :approvals, class_name: "Approval", foreign_key: "round_id", dependent: :destroy
  has_many :approvals_users , through: :approvals, source: :user

  # 画像アップローダー
  mount_uploader :picture, PictureUploader
  
  # 個別メソッド定義
  def owner
    User.find user_id
  end
end
