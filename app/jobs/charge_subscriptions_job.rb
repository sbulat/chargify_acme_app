class ChargeSubscriptionsJob < ApplicationJob
  queue_as :default

  def perform(subscription_id)
    subscription = Subscription.find(subscription_id)
    subscription.charge!
    puts "Subscription ##{subscription_id} scheduled!"
  end
end
