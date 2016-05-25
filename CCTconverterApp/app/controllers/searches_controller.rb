class SearchesController < ApplicationController
  before_action :set_currencies_list, :initiate_search
  attr_accessor :search

  def new; end

  def create
    @search.date = params[:search][:date]
    @search.date = @search.date.to_formatted_s
    @search.ammount = params[:search][:ammount].to_i
    @search.currencyFrom = params[:search][:currencyFrom]
    @search.currencyTo = params[:search][:currencyTo]

    newExch = Conversion.new(@search)
    @search.result = newExch.result
    Rails.cache.write("search", @search)

    redirect_to new_search_path
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

  class Conversion
    attr_accessor :quantity, :ccyFrom, :ccyTo, :date, :result

    def initialize(search)
      @quantity = search.ammount
      @ccyFrom = search.currencyFrom
      @ccyTo = search.currencyTo
      @date = search.date.to_formatted_s
      @result = true

      classifyPerCurrency(quantity, ccyFrom, ccyTo)
      @result
    end

    def classifyPerCurrency(quantity, ccyFrom, ccyTo)
      if ccyFrom == "EUR" || ccyTo == "EUR"
        if ccyFrom == "EUR"
          convertWhereCcyFromIsEuro(quantity, ccyFrom, ccyTo)
        elsif ccyTo == "EUR"
          convertWhereCcyToIsEuro(quantity, ccyFrom, ccyTo)
        end
      else
        convertWhereNotEuroBased(quantity, ccyFrom, ccyTo)
      end
    end

    def convertWhereCcyFromIsEuro(quantity, ccyFrom, ccyTo)
      ccyToRate = getRateFromDatabase(ccyTo, date)

      @result = quantity * ccyToRate
      roundDecimals

      @result
    end

    def convertWhereCcyToIsEuro(quantity, ccyFrom, ccyTo)
      ccyFromRate = getRateFromDatabase(ccyFrom, date)

      rate = 1 / ccyFromRate
      @result = quantity * rate
      roundDecimals

      @result
    end

    def convertWhereNotEuroBased(quantity, ccyFrom, ccyTo)
      ccyFromRate = getRateFromDatabase(ccyFrom, date)
      ccyToRate = getRateFromDatabase(ccyTo, date)

      rate = ccyToRate / ccyFromRate
      @result = quantity * rate
      roundDecimals

      @result
    end

    def getRateFromDatabase(ccy, date)
      rate = 0

      Ecb.all.each do |group|
        if group.date == date && group.currency == ccy
          rate = group.rate
        end
      end

      rate.to_f
    end

    def roundDecimals
      if ccyTo == "JPY"
        @result = @result.round(2)
      else
        @result = @result.round(4)
      end
    end
  end

end
