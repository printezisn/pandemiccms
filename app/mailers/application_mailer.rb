# frozen_string_literal: true

# The base mailer class
class ApplicationMailer < ActionMailer::Base
  default from: Client::DEFAULT_EMAIL
  layout 'mailer'

  protected

  def mail_with_email_template(klass, recipient, values, opts)
    default_opts = {}
    default_opts[:from] = recipient.client.email || Client::DEFAULT_EMAIL
    default_opts[:reply_to] = opts[:from]

    email_template = klass.find_by(client_id: recipient.client.id)&.translate(I18n.locale, use_defaults: true)
    return false unless email_template&.enabled?

    default_opts[:to] = recipient.email
    default_opts[:content_type] = 'text/html'
    default_opts.merge!(email_template.to_email(values))

    mail(default_opts.merge(opts))

    true
  end
end
