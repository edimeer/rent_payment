require 'date'

class RentPayment
  attr_accessor :rent, :rent_changes

  def initialize(rent)
    @rent = rent
    @rent_changes = []
  end

  def add_rent_change(rent_change)
    @rent_changes << rent_change
    @rent_changes.sort_by! { |change| Date.parse(change[:effective_date]) }
  end

  def payment_dates
    start_date = Date.parse(@rent[:start_date])
    end_date = Date.parse(@rent[:end_date])
    payment_method = @rent[:payment_method] || "instant"
    processing_time = payment_processing_time(payment_method)

    dates = []
    current_date = start_date

    while current_date <= end_date
      applicable_amount = find_applicable_rent_amount(current_date)

      payment_date = current_date + processing_time
      break if payment_date >= end_date  # Stop if the payment date exceeds or equal to the end date

      payment_details = { payment_date: payment_date.strftime("%Y-%m-%d"), amount: applicable_amount }

      # Store only dates for the first scenario
      if @rent[:payment_method].nil? && @rent_changes.empty?
        dates << payment_date.strftime("%Y-%m-%d")
      else
        payment_details[:method] = payment_method unless @rent[:payment_method].nil?
        dates << payment_details
      end

      current_date = next_payment_date(current_date, @rent[:frequency])
    end

    dates
  end

  private

  def find_applicable_rent_amount(current_date)
    applicable_amount = @rent[:amount]
    @rent_changes.each do |change|
      change_date = Date.parse(change[:effective_date])
      if change_date <= current_date
        applicable_amount = change[:amount]
      end
    end
    applicable_amount
  end

  def next_payment_date(current_date, frequency)
    case frequency
    when 'weekly'
      current_date + 7
    when 'fortnightly'
      current_date + 14
    when 'monthly'
      current_date >> 1
    else
      raise "Unknown frequency: #{frequency}"
    end
  end

  def payment_processing_time(method)
    case method
    when 'credit_card'
      2
    when 'bank_transfer'
      3
    when 'instant'
      0
    else
      raise "Unknown payment method: #{method}"
    end
  end
end
