class AddUserIdToBalls < ActiveRecord::Migration
  def change
    add_reference :balls, :user, index: true, foreign_key: true
  end
end
