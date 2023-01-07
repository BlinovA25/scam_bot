# frozen_string_literal: true

# Merchant module
module Merchant
  def self.do_payment(credit_card, gateway, sum)
    return unless credit_card.validate.empty?

    response = gateway.purchase(sum, credit_card)

    raise StandardError, response.message unless response.success?

    "Successfully charged #{sum / 100}$ to the credit card #{credit_card.display_number}"
  end
end
