class Subscription < ApplicationRecord
  belongs_to :customer
  belongs_to :product

  # use to periodically charge subscriptions
  def charge!
    # connect with FakepayApi
    # call method responsible for charge
    # update billing_date in subscription record
    puts "Subscription ##{id} charged!"
  end
end
