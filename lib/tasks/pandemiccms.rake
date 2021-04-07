# frozen_string_literal: true

require 'optparse'

namespace :pandemiccms do
  desc 'Initializes the necessary data for the application'
  task init: [:environment] do
    languages = [
      Language.new(locale: 'en', name: 'English', flag: 'gb'),
      Language.new(locale: 'el', name: 'Ελληνικά', flag: 'gr', transliterations: 'greek')
    ]

    languages.each do |language|
      language.save! unless Language.exists?(locale: language.locale)
    end
  end

  desc 'Creates a new client'
  task create_client: [:environment] do
    locales = []
    email_templates = []
    all_locales = Language.pluck(:locale)
    all_email_templates = EmailTemplateType.constants.map do |c|
      EmailTemplateType.const_get(c).name.gsub('EmailTemplateType::', '')
    end

    client = Client.new(time_zone: 'UTC')

    option_parser = OptionParser.new
    option_parser.banner = 'Usage: rake pandemiccms:create_client -- [OPTIONS]'
    option_parser.on('-n NAME', '--name NAME', 'The name of the client') do |name|
      client.name = name
    end
    option_parser.on('-t', '--template NAME', 'The template used for the client.') do |template|
      client.template = template
    end
    option_parser.on('-d', '--domain DOMAIN:PORT',
                     'A domain of the client along with the port (e.g. mysite:80). Can be used multiple times.') do |domain_and_port|
      client.client_domains.build(
        domain: domain_and_port.split(':')[0],
        port: domain_and_port.split(':')[1]
      )
    end
    option_parser.on('-l', '--language LOCALE', 'An available language of the client (e.g. en, el), Can be used multiple times.') do |locale|
      locales << locale if all_locales.include?(locale)
    end
    option_parser.on('-e', '--email-template NAME',
                     'An email template of the client (e.g. AccountConfirmation). Can be used multiple times.') do |email_template|
      email_templates << email_template if all_email_templates.include?(email_template)
    end

    args = option_parser.order!(ARGV) {}
    option_parser.parse!(args)

    locales = all_locales if locales.blank?
    email_templates = all_email_templates if email_templates.blank?

    locales.each { |locale| client.client_languages.build(language: Language.find_by(locale: locale)) }
    email_templates.each do |email_template|
      client.email_templates << "EmailTemplateType::#{email_template}".constantize.new
    end

    puts "The client could not be created because of the following errors: #{client.errors.messages}" unless client.save
    exit 0
  end

  desc 'Creates a new supervisor user'
  task create_supervisor: [:environment] do
    admin_user = AdminUser.new

    option_parser = OptionParser.new
    option_parser.banner = 'Usage: rake pandemiccms:create_supervisor -- [OPTIONS]'
    option_parser.on('-u USERNAME', '--username USERNAME', 'The username of the supervisor.') do |username|
      admin_user.username = username
    end
    option_parser.on('-e EMAIL', '--email EMAIL', 'The email of the supervisor.') do |email|
      admin_user.email = email
    end
    option_parser.on('-p PASSWORD', '--password PASSWORD', 'The password of the supervisor.') do |password|
      admin_user.password = password
      admin_user.password_confirmation = password
    end
    option_parser.on('-c CLIENT_NAME', '--client-name CLIENT_NAME', 'The name of the client.') do |client_name|
      admin_user.client = Client.find_by!(name: client_name)
    end

    args = option_parser.order!(ARGV) {}
    option_parser.parse!(args)

    unless admin_user.save
      puts "The supervisor could not be created because of the following errors: #{admin_user.errors.messages}"
      exit 0
    end
    admin_user.supervisor!
    admin_user.confirm

    exit 0
  end
end
