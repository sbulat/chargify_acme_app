module Api
  class SubscriptionsController < ApplicationController
    def create
      card = CreditCard.new(credit_card_params)
      unless card.valid?
        redirect_to(root_url, alert: 'Credit card data not provided') && return
      end

      @customer = Customer.new { |c| c.shipping_info = shipping_params }
      unless @customer.save
        redirect_to(root_url, alert: 'Customer data not provided') && return
      end

      @payment_status = MakePaymentService.new(
        card, params[:product], @customer.id
      ).perform
    end

    private

    def shipping_params
      params.require(:shipping).permit(
        :client_name, :client_address, :client_zip_code
      )
    end

    def credit_card_params
      params.require(:billing).permit(
        :card_number, :exp_month, :exp_year, :cvv, :zip_code
      )
    end
  end
end
