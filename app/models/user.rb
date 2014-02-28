class User < ActiveRecord::Base
  validates :email, :city, :presence => true
  validates :fair_price, :presence => true, numericality: {greater_than_or_equal_to: 3}
  
  scope :grep_users, ->(city) { where(:city => city, :status => "Completed") }
end
