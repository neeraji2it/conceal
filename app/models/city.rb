class City < ActiveRecord::Base
  scope :uniquely_city, group(:city)
end
