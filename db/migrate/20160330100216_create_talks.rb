class CreateTalks < ActiveRecord::Migration
  def change
    create_table :talks do |t|
      t.references :user, index: true, foreign_key: true
      t.references :round, index: true, foreign_key: true
      t.text :content

      t.timestamps null: false
    end
  end
end
