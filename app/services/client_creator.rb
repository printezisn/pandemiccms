# frozen_string_literal: true

# Service class to create a client
class ClientCreator < ApplicationService
  def initialize(name, template, domains_and_ports, locales, email_templates, supervisor_email)
    super()

    @name = name
    @template = template
    @domains_and_ports = domains_and_ports
    @locales = locales
    @email_templates = email_templates
    @supervisor_email = supervisor_email
  end

  def call
    errors = []

    ActiveRecord::Base.transaction do
      LanguageInitializer.call

      available_locales = Language.pluck(:locale)
      available_email_templates = EmailTemplateType.constants.map do |c|
        EmailTemplateType.const_get(c).name.gsub('EmailTemplateType::', '')
      end

      valid_locales = available_locales.select { |l| locales.blank? || locales.include?(l) }
      valid_email_templates = available_email_templates.select { |e| email_templates.blank? || email_templates.include?(e) }

      client = Client.new(name: name, template: template, time_zone: 'UTC')
      domains_and_ports.each do |domain_and_port|
        client.client_domains.build(domain: domain_and_port.split(':')[0], port: domain_and_port.split(':')[1])
      end
      valid_locales.each { |locale| client.client_languages.build(language: Language.find_by!(locale: locale)) }
      valid_email_templates.each { |email_template| client.email_templates << "EmailTemplateType::#{email_template}".constantize.new }

      unless client.save
        errors = client.errors.messages
        raise ActiveRecord::Rollback
      end

      admin_user = client.admin_users.build(username: 'admin', email: supervisor_email)
      admin_user.set_random_password

      unless admin_user.save
        errors = admin_user.errors.messages
        raise ActiveRecord::Rollback
      end

      admin_user.supervisor!

      "ThemeInitializer::#{template.camelize}".constantize.call(client, admin_user)
    end

    errors
  end

  private

  attr_reader :name, :template, :domains_and_ports, :locales, :email_templates, :supervisor_email
end
