class CreateApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :applications do |t|
      t.string :name
      t.string :street_address
      t.string :city
      t.string :state
      t.integer :zip
      t.string :description
      t.integer :chosen_pets_id, array: true
      t.string :app_status
    end
  end
end
