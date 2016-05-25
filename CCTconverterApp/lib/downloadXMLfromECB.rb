# This is MY_solution.rb that outputs a file called ecb.csv

require 'open-uri'
require 'nokogiri'
require 'csv'
require 'money'
require 'pry'


url = 'http://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml'.freeze

page = Nokogiri::XML(open(url))
rates = page.xpath('gesmes:Envelope/xmlns:Cube/xmlns:Cube//xmlns:Cube')

table = []
currency = "currency"
rate = "rate"
date = "date"
table[0] = [currency, rate, date]

rates.each do |exchange_rate|
  rate = exchange_rate.attribute("rate").value
  currency = exchange_rate.attribute("currency").value
  date = exchange_rate.parent.attribute("time").value

  table[table.length + 1] = [currency, rate, date]
end

table.delete_if do |field|
  field == nil
end

CSV.open("CCTconverterApp/lib/ecbs.csv", "w") do |csv|
  table.each do |item|
    csv << item
  end
end
