class CreatePaticipations < ActiveRecord::Migration
  def change
    create_table :paticipations do |t|
      t.references :user, index: true, foreign_key: true
      t.references :round, index: true, foreign_key: true

      t.timestamps null: false
      t.index [:user_id, :round_id], unique: true # この行を追加
    end
  end
end
