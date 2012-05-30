class Order < ActiveRecord::Base
  CURRENTIES = Robokassa.get_currencies
  attr_accessible :currency, :price
  attr_reader :currenties

  def get_pay
  		merchant_url = Robokassa::MERCHANT_URL
  		login = Robokassa::MERCHANT_LOGIN
  		pass = Robokassa::MERCHANT_PASS_1
		  #price = Robokassa::get_rates(self.currency,self.price)
	    sign = Digest::MD5.hexdigest([login,self.price, 1.to_s, pass].join(':'))

		req_url = "#{merchant_url}?MrchLogin=#{login}&OutSum=#{price}&InvId=1&SignatureValue=#{sign}&IncCurrLabel=#{self.currency}&Culture=ru"

  end 
  
end
