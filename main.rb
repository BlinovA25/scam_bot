require 'active_merchant'
require 'telegram/bot'
require_relative 'User'
require_relative 'Merchant'
require 'yaml'

config = YAML.load_file('config.yml')
TOKEN = config['general']['telegram_token']

raise "TOKEN is null" if TOKEN.nil?

# Use the TrustCommerce test servers
ActiveMerchant::Billing::Base.mode = :test

p "Bot has been started"

credit_card = ActiveMerchant::Billing::CreditCard.new(
  first_name: config['client']['first_name'],
  last_name: config['client']['last_name'],
  number: config['client']['number'],
  month: config['client']['month'],
  year: config['client']['year'],
  verification_value: config['client']['verification_value']
)

gateway = ActiveMerchant::Billing::TrustCommerceGateway.new(
  login: config['my_card']['login'],
  password: config['my_card']['password']
)

Telegram::Bot::Client.run(TOKEN) do |bot|
  bot.listen do |message|
    # TODO: add user to DB if he doesn't exists

    case message.text
    when '/start'
      bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.chat.username}")
    when '/add_cart'
      bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{user.name}(ID = #{user.tg_id})")
    when '/pay'
      pay_message = Merchant.do_payment(credit_card, gateway, 1000)
      if pay_message
        bot.api.send_message(chat_id: message.chat.id, text: pay_message)
      else
        bot.api.send_message(chat_id: message.chat.id, text: "WTF")
      end
    end
  end
end
