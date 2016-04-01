class AddColumnsToRounds < ActiveRecord::Migration
  def change
    add_column :rounds, :address, :string
    add_column :rounds, :latitude, :float
    add_column :rounds, :longitude, :float
  end
end
