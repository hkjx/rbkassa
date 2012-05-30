class Order < ActiveRecord::Base
  attr_accessible :currency, :price
end
