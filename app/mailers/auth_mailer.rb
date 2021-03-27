# frozen_string_literal: true

# Mailer for auth operations
class AuthMailer < Devise::Mailer
  def confirmation_instructions(record, token, opts = {})
    values = {
      '{user.fullname}' => record.full_name,
      '{user.username}' => record.username,
      '{user.email}' => record.email,
      '{user.confirmation_link}' => admin_user_confirmation_url(
        record,
        record.client.default_url_options.merge(confirmation_token: token, locale: I18n.locale, format: '')
      )
    }

    super unless mail_with_email_template(EmailTemplateType::AccountConfirmation, record, values, opts)
  end

  def reset_password_instructions(record, token, opts = {})
    values = {
      '{user.fullname}' => record.full_name,
      '{user.username}' => record.username,
      '{user.email}' => record.email,
      '{user.reset_password_link}' => edit_admin_user_password_url(
        record,
        record.client.default_url_options.merge(reset_password_token: token, locale: I18n.locale, format: '')
      )
    }

    super unless mail_with_email_template(EmailTemplateType::ResetPasswordInstructions, record, values, opts)
  end

  def email_changed(record, opts = {})
    values = {
      '{user.fullname}' => record.full_name,
      '{user.username}' => record.username,
      '{user.email}' => record.email,
      '{user.unconfirmed_email}' => record.unconfirmed_email
    }

    super unless mail_with_email_template(EmailTemplateType::EmailChange, record, values, opts)
  end

  def password_change(record, opts = {})
    values = {
      '{user.fullname}' => record.full_name,
      '{user.username}' => record.username,
      '{user.email}' => record.email
    }

    super unless mail_with_email_template(EmailTemplateType::PasswordChange, record, values, opts)
  end
end
