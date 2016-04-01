class AddTypeToPaticipations < ActiveRecord::Migration
  def change
    add_column :paticipations, :type, :string
  end
end
