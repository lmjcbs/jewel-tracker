class ChangeTypeColumn < ActiveRecord::Migration
  def change
    rename_column :jewels, :type, :name
  end
end
