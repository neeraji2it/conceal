class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :city
      t.float :fair_price
      t.float :one_time_donation
      t.string :name
      t.string :email
      t.string :status, :default => "Pending"
      t.timestamps
    end
  end
end
