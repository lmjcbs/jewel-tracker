class AddUseridColumn < ActiveRecord::Migration
  def change
    add_column :jewels, :user_id, :integer
  end
end
