class AddUserRefToRounds < ActiveRecord::Migration
  def change
    add_reference :rounds, :user, index: true, foreign_key: true
  end
end
