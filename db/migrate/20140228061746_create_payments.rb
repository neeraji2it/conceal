class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :user_id
      t.string :first_name
      t.string :last_name
      t.string :card_type
      t.date :card_expires_on
      t.string :action
      t.float :amount
      t.boolean :success
      t.string :authorization
      t.string :message
      t.text :params
      t.string :address
      t.string :state
      t.string :country
      t.string :zip  
      t.string :phone_number
      t.string :fax_number
      t.string :customer_profile_id
      t.string :customer_payment_profile_id
      t.timestamps
    end
  end
end
