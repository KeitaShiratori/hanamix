class Talk < ActiveRecord::Base
  validates :content, length: { maximum: 300 }

  belongs_to :user
  belongs_to :round
end
