class CreateHubs < ActiveRecord::Migration[5.1]
  def change
    create_table :hubs do |t|
      t.string :name

      t.timestamps
    end
  end
end
