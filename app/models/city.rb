class City < ActiveRecord::Base
  scope :uniquely_city, select("city").group("city")
end
