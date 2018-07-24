namespace :subscriptions do
  desc 'Charge all subscriptions planned for given day'
  task :charge, [:date] => :environment do |t, args|
    date = Date.parse.in_time_zone(args[:date]) || Date.current
    Subscription.where(billing_date: date).pluck(:id).each do |id|
      ChargeSubscriptionsJob.perform_later(id)
    end
  end
end
