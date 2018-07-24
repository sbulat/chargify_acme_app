module ApplicationHelper
  def error_message(code)
    case code
    when 1000001 then 'Invalid credit card number'
    when 1000002 then 'Insufficient funds'
    when 1000003 then 'CVV failure'
    when 1000004 then 'Expired card'
    when 1000005 then 'Invalid zip code'
    when 1000006 then 'Invalid purchase amount'
    end
  end
end
