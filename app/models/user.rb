class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  
  # バリデーション定義
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :description, length: { maximum: 500 }
  validates :location, length: { maximum: 100 }
  has_secure_password
  
  # リレーションシップ定義
  has_many :balls

  # モデルメソッド定義

end
