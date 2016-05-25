class SearchesController < ApplicationController
  before_action :set_currencies_list, :initiate_search
  attr_accessor :search
  # , :initiate_search, :declare_result

  def index
  end

  def show

  end

  def new
    # Rails.cache.read("search")
    # binding.pry
    # @search = Search.new
  end

  def create
    # @search = Search.new

    date = params[:search][:date]                       # "2016/03/25"
    ammount = params[:search][:ammount].to_i                 # "100"
    currencyFrom = params[:search][:currencyFrom]       # "AUD"
    currencyTo = params[:search][:currencyTo]           # "EUR"

    @search.date = params[:search][:date]                       # "2016/03/25"
    @search.ammount = params[:search][:ammount].to_i                 # "100"
    @search.currencyFrom = params[:search][:currencyFrom]       # "AUD"
    @search.currencyTo = params[:search][:currencyTo]           # "EUR"

    newExch = Conversion.new(ammount, currencyFrom, currencyTo, date)
    # binding.pry

    @search.result = newExch.result
    # binding.pry

    Rails.cache.write("search", @search)

    redirect_to new_search_path    # TEMPORARY FOR DEVELOPMENT PURPOSES
    # RENDER SEARCHES#NEW AGAIN ++++@VAR WITH RESULT  ????
  end

  def edit

  end

  def update

  end

  # DB = {
  #   "USD" => 1.1219,
  #   "GBP" => 0.77008,
  #   "JPY" => 123.81,
  #   "AUD" => 1.5519,
  #   "CAD" => 1.4704
  # }


  class Conversion
    # include EuroRates
    attr_accessor :quantity, :ccyFrom, :ccyTo, :date, :result

    def initialize(quantity, ccyFrom, ccyTo, date)
      @quantity = quantity.to_i
      @ccyFrom = ccyFrom
      @ccyTo = ccyTo
      @date = date.gsub("/","-")
      @result = true

      # binding.pry
      isEur?(quantity, ccyFrom, ccyTo)
      @result
    end

    def isEur?(quantity, ccyFrom, ccyTo)
      if ccyFrom == "EUR" || ccyTo == "EUR"
        if ccyFrom == "EUR"
          ccyFromIsEur(quantity, ccyFrom, ccyTo)
        elsif ccyTo == "EUR"
          ccyToIsEur(quantity, ccyFrom, ccyTo)
        end
      else
        notEuroBased(quantity, ccyFrom, ccyTo)
      end
    end

    def ccyFromIsEur(quantity, ccyFrom, ccyTo)
      ccyToRate = getRateFromDatabase(ccyTo, date)

      @result = quantity * ccyToRate
      # binding.pry
      # result = quantity * DB[ccyTo]
      # puts "#{quantity} #{ccyFrom} to #{ccyTo} = #{result}"
      isJPY?
      @result
    end

    def ccyToIsEur(quantity, ccyFrom, ccyTo)
      ccyFromRate = getRateFromDatabase(ccyFrom, date)

      rate = 1 / ccyFromRate
      # rate = 1 / DB[ccyFrom]
      @result = quantity * rate
      # puts "#{quantity} #{ccyFrom} to #{ccyTo} = #{result}"
      @result
    end

    def notEuroBased(quantity, ccyFrom, ccyTo)
      ccyFromRate = getRateFromDatabase(ccyFrom, date)
      ccyToRate = getRateFromDatabase(ccyTo, date)

      rate = ccyToRate / ccyFromRate
      @result = quantity * rate
      # puts "#{quantity} #{ccyFrom} to #{ccyTo} = #{result}"
      isJPY?
      @result
    end

    def getRateFromDatabase(ccy, date) # +++ DATE!!!
      rate = 0

      Ecb.all.each do |group|
        if group.date == date && group.currency == ccy
          rate = group.rate
        end
      end

      rate.to_f
    end

    def isJPY?
      # binding.pry
      if ccyTo == "JPY"
        @result = @result.round(2)
      else
        @result = @result.round(4)
      end
    end
  end



  private

  def set_currencies_list
    @currencies = %w(EUR USD JPY BGN CZK DKK GBP HUF ILS PLN RON SEK CHF NOK HRK RUB TRY AUD BRL CAD CNY HKD IDR INR KRW MXN MYR NZD PHP SGD THB ZAR)
  end

  def initiate_search
    if !search
      if Rails.cache.read("search")
        @search = Rails.cache.read("search")
      else
        @search = Search.new
      end
    end
  end

  # def declare_result
  #   binding.pry
  #   if !@result then @result = 0 end
  # end

end
