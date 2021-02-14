# frozen_string_literal: true

# The base mailer class
class ApplicationMailer < ActionMailer::Base
  default from: Client::DEFAULT_EMAIL
  layout 'mailer'

  protected

  def fetch_email_template_type(klass, recipient, values, opts)
    opts[:from] = recipient.client.email || Client::DEFAULT_EMAIL
    opts[:reply_to] = opts[:from]

    email_template = klass.find_by(client_id: recipient.client.id)&.translate(I18n.locale, use_defaults: true)
    return false unless email_template&.enabled?

    opts[:to] = recipient.email
    opts[:content_type] = 'text/html'
    opts.merge!(email_template.to_email(values))

    mail(opts)

    true
  end
end
