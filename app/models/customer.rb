class Customer < ApplicationRecord
  has_many :subscriptions

  validates :first_name, :last_name, :address, :shipping_zip_code,
    presence: true

  def shipping_info=(info)
    names = info[:client_name].split(' ')
    self.first_name = names.first
    self.last_name = names.last
    self.address = info[:client_address]
    self.shipping_zip_code = info[:client_zip_code]
  end
end
