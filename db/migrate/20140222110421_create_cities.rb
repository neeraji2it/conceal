class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :zipcode
      t.string :latitude
      t.string :longitude
      t.string :city
      t.string :state
      t.string :state_abbr
      
      t.timestamps
    end
  end
end
