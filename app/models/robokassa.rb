require 'open-uri'
require 'nokogiri'

class Robokassa

  MERCHANT_URL = ROBOKASSA_CONFIG['merchant_url']
  SERVICES_URL = ROBOKASSA_CONFIG['services_url']
  MERCHANT_LOGIN = ROBOKASSA_CONFIG['merchant_login']
  MERCHANT_PASS_1 = ROBOKASSA_CONFIG['merchant_pass1']
  MERCHANT_PASS_2 = ROBOKASSA_CONFIG['merchant_pass2']
  

  def self.get_payment_methods(lang = "ru")
  	req_url = "#{SERVICES_URL}/GetPaymentMethods?MerchantLogin=#{MERCHANT_LOGIN}&Language=#{lang}"
  	doc = Nokogiri::XML(open(req_url))
  	if doc.xpath("//xmlns:Result/xmlns:Code").text.to_i == 0
      doc.xpath("//xmlns:Method").map do |m|
        {:code => m["Code"], :desc => m["Description"]}
      end
  	end
  end

  def self.get_rates (currency, out_summ, lang = "ru")
  	req_url="http://test.robokassa.ru/Webservice/Service.asmx/GetRates?MerchantLogin=#{MERCHANT_LOGIN}&IncCurrLabel=#{currency}&OutSum=#{out_summ}&Language=ru"
  	doc = Nokogiri::XML(open(req_url)).remove_namespaces!
  	if doc.xpath("//Result/Code").text.to_i == 0
		  doc.xpath("//*[@Label='#{currency}']/Rate").first["IncSum"].to_f
  	end
  end 

def self.get_currencies(webmoney = true, lang = "ru")
    req_url = "#{SERVICES_URL}/GetCurrencies?MerchantLogin=#{MERCHANT_LOGIN}&Language=#{lang}"
    doc = Nokogiri::XML(open(req_url)).remove_namespaces!

    if doc.xpath("//Result/Code").text.to_i == 0 
         result = doc.xpath("//*[@Code='EMoney']//Currency").map do |c|
            c = [c["Name"], c["Label"]]
         end

         result += doc.xpath("//*[@Code='BankCard']//Currency").map do |c|
            c = [c["Name"], c["Label"]]    
          end   
  end
  end
end
