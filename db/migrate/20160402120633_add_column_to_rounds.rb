class AddColumnToRounds < ActiveRecord::Migration
  def change
    add_column :rounds, :appear_in_url, :string
  end
end
