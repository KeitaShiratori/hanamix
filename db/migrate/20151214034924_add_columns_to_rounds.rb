class AddColumnsToRounds < ActiveRecord::Migration
  def change
    add_column :rounds, :address, :stiring
    add_column :rounds, :latitude, :float
    add_column :rounds, :longitude, :float
  end
end
