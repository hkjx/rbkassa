require 'open-uri'

ROBOKASSA_CONFIG = YAML.load_file("#{Rails.root}/config/robokassa.yml")
CURRENTIES = [["test", "test"], ["test1", "test1"]]#Robokassa.get_currencies

	req_url = "#{ROBOKASSA_CONFIG['services_url']}/GetCurrencies?MerchantLogin=#{ROBOKASSA_CONFIG['merchant_login']}&Language=ru"
  	
  	doc = Nokogiri::XML(open(req_url)).remove_namespaces!

  	if doc.xpath("//Result/Code").text.to_i == 0 
	       CURRENTIES = doc.xpath("//*[@Code='EMoney']//Currency").map do |c|
	      		c = [c["Name"], c["Label"]]
	       end

	       # result += doc.xpath("//*[@Code='BankCard']//Currency").map do |c|
	      	#  	c = [c["Name"], c["Label"]]	   
	      	# end 	
	end