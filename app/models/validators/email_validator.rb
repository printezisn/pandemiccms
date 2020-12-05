# frozen_string_literal: true

require 'uri'

# Email validator for active models
class EmailValidator < ActiveModel::Validator
  def validate(record)
    return if record.email.match? URI::MailTo::EMAIL_REGEXP

    record.errors.add(:email, I18n.t('errors.messages.invalid_email'))
  end
end
