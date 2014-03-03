class User < ActiveRecord::Base
  validates :email, :city, :presence => true
  validates :fair_price, :presence => true, numericality: {greater_than_or_equal_to: 3}
  
  scope :grep_users, ->(city) { where(:city => city, :status => "Completed") }
  scope :highest_rated, -> {select("users.city, AVG(users.fair_price) as avg_price, COUNT(users.id) as users_count").where(:status => "Completed").group(:city).order("avg_price DESC").limit(5)}
end
