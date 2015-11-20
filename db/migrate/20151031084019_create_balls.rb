class CreateBalls < ActiveRecord::Migration
  def change
    create_table :balls do |t|
      t.string :title
      t.string :description
      t.string :address
      t.float :latitude
      t.float :longitude
      t.float :height
      t.references :round, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
