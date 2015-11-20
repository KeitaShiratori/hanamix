class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.string :title
      t.string :description
      t.datetime :start_at
      t.datetime :end_at

      t.timestamps null: false
    end
  end
end
