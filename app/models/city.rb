class City < ActiveRecord::Base
  scope :uniquely_city, select("id, city").group("city")
end
