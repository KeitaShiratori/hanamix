class User < ActiveRecord::Base
  ROLE_GUEST = "guest"
  ROLE_USER  = "user"

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
  has_many :talks
  has_many :paticipations, dependent: :destroy
  has_many :paticipate_rounds, through: :paticipations, source: :round
  has_many :wishes, dependent: :destroy
  has_many :wishes_rounds, through: :wishes, source: :round
  has_many :approvals, dependent: :destroy
  has_many :approvals_rounds, through: :approvals, source: :round

  # モデルメソッド定義
  # ラウンドに参加する
  def paticipate round
    paticipations.create(round_id: round.id)
  end

  # ラウンドの参加を取り消す
  def unpaticipate round
    paticipations.find_by(round_id: round.id).destroy
  end

  # あるラウンドに参加しているかどうか？
  def paticipate? round
    paticipate_rounds.include?(round)
  end

  # 0次会に参加希望する
  def wish round
    wishes.create(round_id: round.id)
  end

  # 0次会に参加希望を取り消す
  def unwish round
    wishes.find_by(round_id: round.id).destroy
  end

  # 0次会に参加希望しているかどうか？
  def wish? round
    wishes_rounds.include?(round)
  end

  # 0次会に参加承認する
  def approve round
    wishes.find_by(round_id: round.id).update_attribute(:type, "Approval")
  end

  # 0次会に参加希望を取り消す
  def unapprove round
    approvals.find_by(round_id: round.id).destroy
  end

  # 0次会に参加希望しているかどうか？
  def approve? round
    approvals_rounds.include?(round)
  end

  def self.create_guest session
    @user = User.new do |u|
      u.name        = I18n.t('users_create_guest.name')
      u.description = I18n.t('users_create_guest.description')
      u.location    = I18n.t('users_create_guest.location')
      u.email       = "guest_#{Time.now.to_i}#{rand(100)}@hanamix.com"
      u.role        = ROLE_GUEST
      u.password    = u.email
      
      u.save!
      
      session[:user_id] = u.id
    end
  end
  
  def guest?
    ROLE_GUEST == role
  end
end
