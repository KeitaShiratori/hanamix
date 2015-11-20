class Ball < ActiveRecord::Base
  # バリデーション定義
  validates :round_id, presence: true

  # リレーション定義
  belongs_to :round
  belongs_to :user
  
  geocoded_by :address
  after_validation :geocode
  
  # モデルメソッド定義
  def has_owner
    !!self.user_id
  end

  def owner
    User.find(self.user_id)
  end
  
  def owner user_id
    self.user_id = user_id
    self.save!
  end
  
  def distance lat, lng
    dx = self.latitude - lat
    dy = self.longitude - lng
    dx * dx + dy * dy
  end
end
