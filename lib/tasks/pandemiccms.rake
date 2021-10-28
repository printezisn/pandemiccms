# frozen_string_literal: true

require 'optparse'

namespace :pandemiccms do
  desc 'Creates a new client'
  task create_client: [:environment] do
    name = ''
    template = ''
    domains_and_ports = []
    locales = []
    email_templates = []
    supervisor_email = ''

    option_parser = OptionParser.new
    option_parser.banner = 'Usage: rake pandemiccms:create_client -- [OPTIONS]'
    option_parser.on('-n NAME', '--name NAME', 'The name of the client') do |name_option|
      name = name_option
    end
    option_parser.on('-t', '--template NAME', 'The template used for the client.') do |template_option|
      template = template_option
    end
    option_parser.on('-d', '--domain DOMAIN:PORT',
                     'A domain of the client along with the port (e.g. mysite:80). Can be used multiple times.') do |domain_and_port|
      domains_and_ports << domain_and_port
    end
    option_parser.on('-l', '--language LOCALE',
                     'An available language of the client (e.g. en-GB, el-GR). Can be used multiple times. If none is specified, ' \
                     'then the client is considered to have all available languages.') do |locale|
      locales << locale
    end
    option_parser.on('-e', '--email-template NAME',
                     'An email template of the client (e.g. AccountConfirmation). Can be used multiple times. If none is specified, ' \
                     'then the client is considered to have all available email templates.') do |email_template|
      email_templates << email_template
    end
    option_parser.on('-s', '--supervisor-email EMAIL',
                     "The email of the client's supervisor user") do |supervisor_email_option|
      supervisor_email = supervisor_email_option
    end

    args = option_parser.order!(ARGV) {}
    option_parser.parse!(args)

    errors = ClientCreator.call(name, template, domains_and_ports, locales, email_templates, supervisor_email)

    puts "The client could not be created because of the following errors: #{errors}" if errors.present?
    exit 0
  end
end
