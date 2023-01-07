# frozen_string_literal: true

# User class
class User
  attr_accessor :username, :chat_id, :phone_number, :first_name, :last_name, :number, :month, :year, :verification_value

  def initialize(username, chat_id, phone_number = "")
    @username = username
    @chat_id = chat_id
    @phone_number = phone_number
  end

  def add_card(first_name, last_name, number, month, year, verification_value)
    @first_name = first_name
    @last_name = last_name
    @number = number
    @month = month
    @year = year
    @verification_value = verification_value
  end
end
