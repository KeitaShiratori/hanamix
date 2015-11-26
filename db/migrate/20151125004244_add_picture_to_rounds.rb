class AddPictureToRounds < ActiveRecord::Migration
  def change
    add_column :rounds, :picture, :string
  end
end
