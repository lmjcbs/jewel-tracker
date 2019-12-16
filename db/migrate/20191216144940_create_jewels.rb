class CreateJewels < ActiveRecord::Migration
  def change
    create_table :jewels do |t|
      t.string :type
      t.string :weight
      t.string :colour
      t.string :location_found
      t.string :value
    end
  end
end
