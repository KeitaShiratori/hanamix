class AddColmunsToRounds < ActiveRecord::Migration
  def change
    add_column :rounds, :lat, :string
    add_column :rounds, :lng, :string
  end
end
