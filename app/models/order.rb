class Order < ActiveRecord::Base
  attr_accessible :currency, :price, :inv_id, :user_id
  validates :price, :format => { :with => /^\d+??(?:\.\d{0,2})?$/ }, :numericality => {:greater_than => 0}

  def get_pay
  		merchant_url = Robokassa::MERCHANT_URL
  		login = Robokassa::MERCHANT_LOGIN
  		pass = Robokassa::MERCHANT_PASS_1
		  current_price = Robokassa::get_rates(self.currency,self.price)
	    sign = Digest::MD5.hexdigest([login,current_price, "" , pass,"shp_currency=#{currency}","shp_prc=#{self.price}", "shp_uid=#{user_id}"].join(':'))

		req_url = "#{merchant_url}?MrchLogin=#{login}&OutSum=#{current_price}&InvId=&SignatureValue=#{sign}&IncCurrLabel=#{self.currency}&Culture=ru&shp_uid=#{user_id}&shp_currency=#{currency}&shp_prc=#{self.price}"

  end 
  
end
