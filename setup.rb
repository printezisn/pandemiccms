# frozen_string_literal: true

require 'io/console'

ActiveRecord::Base.transaction do
  if Language.none?
    puts 'Creating languages...'
    Language.create!(locale: 'en', name: 'English', flag: 'gb')
    Language.create!(locale: 'el', name: 'Ελληνικά', flag: 'gr', transliterations: 'greek')
  end

  client = Client.new

  puts 'Enter details about the client:'
  print 'Name: '
  client.name = gets.chomp.strip
  print 'Time zone: '
  client.time_zone = gets.chomp.strip
  print 'Domains and ports (e.g. localhost:3000,mysite.com:80): '
  gets.chomp.split(',').each do |domain_and_port|
    parts = domain_and_port.strip.split(':')
    client.client_domains.build(domain: parts[0], port: parts[1])
  end
  print 'Template: '
  client.template = gets.chomp.strip
  print 'Show search page (y/n): '
  client.show_search_page = gets.chomp.strip.casecmp('y').zero?
  print 'Show category page (y/n): '
  client.show_category_page = gets.chomp.strip.casecmp('y').zero?
  print 'Show tag page (y/n): '
  client.show_tag_page = gets.chomp.strip.casecmp('y').zero?
  print 'Available languages (e.g. en,el): '
  gets.chomp.split(',').each do |locale|
    client.languages << Language.find_by(locale: locale.strip)
  end
  print 'Enabled languages (e.g. en,el): '
  gets.chomp.split(',').each do |locale|
    client.client_languages.detect { |l| l.language.locale == locale }.update!(enabled: true)
  end
  print 'Default language (e.g. en): '
  default_locale = gets.chomp.strip
  client.client_languages.detect { |l| l.language.locale == default_locale }.update!(default: true)

  client.save!

  EmailTemplateType::AccountConfirmation.create!(client: client)
  EmailTemplateType::ResetPasswordInstructions.create!(client: client)
  EmailTemplateType::PasswordChange.create!(client: client)
  EmailTemplateType::EmailChange.create!(client: client)

  admin_user = AdminUser.new(client_id: client.id)

  puts
  puts 'Enter details about the supervisor user:'
  print 'Username: '
  admin_user.username = gets.chomp.strip
  print 'Email: '
  admin_user.email = gets.chomp.strip
  print 'Password: '
  admin_user.password = IO.console.getpass
  print 'Confirm password: '
  admin_user.password_confirmation = IO.console.getpass

  admin_user.save!
  admin_user.supervisor!
  admin_user.confirm
rescue StandardError => e
  puts e
  raise
end
