class CreditCard
  attr_reader :number, :exp_month, :exp_year, :cvv, :zip_code

  def initialize(billing)
    @number = billing[:card_number]
    @exp_month = billing[:exp_month]
    @exp_year = billing[:exp_year]
    @cvv = billing[:cvv]
    @zip_code = billing[:zip_code]
  end

  def valid?
    !(number.empty? || exp_month.empty? || exp_year.empty? ||
      cvv.empty? || zip_code.empty?)
  end
end
