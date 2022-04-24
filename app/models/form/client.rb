# frozen_string_literal: true

module Form
  # Form model class to create and update a client
  class Client
    include ActiveModel::Model

    attr_accessor :client_name, :client_template, :domains, :ports, :language_ids, :default_language_id,
                  :admin_email, :admin_username, :admin_password, :admin_password_confirmation
    attr_reader :client, :all_languages, :templates

    validates :client_name, presence: true, length: { maximum: 255 }
    validate :validate_client_template
    validate :validate_domains
    validate :validate_ports
    validates :admin_email, presence: true
    validates :admin_email, format: { with: URI::MailTo::EMAIL_REGEXP },
                            length: { maximum: 255 },
                            if: -> { admin_email.present? }
    validates :admin_username, presence: true
    validates :admin_username, format: { with: /\A[A-Za-z0-9.\-]*\z/ },
                               length: { maximum: 50 },
                               if: -> { admin_username.present? }
    validates :admin_password, presence: true
    validates :admin_password, format: { with: AdminUser::PASSWORD_REGEX },
                               length: { maximum: 128 },
                               confirmation: { case_sensitive: false },
                               if: -> { admin_password.present? }

    def initialize(attributes = {})
      super(attributes)

      @all_languages = Language.all.to_a
      @templates = fetch_templates
      @domains = [''] if domains.blank?
      @ports = [''] if ports.blank?
      @language_ids = [] if language_ids.blank?
    end

    def save
      return false if invalid?

      @client = ::Client.new(
        name: client_name,
        template: client_template,
        time_zone: 'UTC'
      )

      domains_and_ports = domains.each_index.map { |i| [domains[i], ports[i]] }.uniq
      domains_and_ports.each { |domain, port| client.client_domains.build(domain:, port:) }

      language_ids.each do |language_id|
        language = all_languages.detect { |l| l.id.to_s == language_id }
        next unless language

        client.client_languages.build(
          language_id: language.id,
          default: language.id.to_s == default_language_id
        )
      end

      admin_user = client.admin_users.build(
        email: admin_email,
        username: admin_username,
        password: admin_password,
        password_confirmation: admin_password_confirmation,
        role: :supervisor,
        should_set_roles: true
      )

      !!ActiveRecord::Base.transaction do
        client.save!
        "ThemeInitializer::#{client.template.camelize}".constantize.call(client, admin_user)

        true
      end
    end

    private

    def fetch_templates
      path = Rails.root.join('app/views/templates/*')
      @templates = Dir[path].map { |f| File.basename(f) }
    end

    def validate_client_template
      return if templates.include?(client_template)

      errors.add(:client_template, :blank)
    end

    def validate_domains
      total_domains = [domains.size, ports.size].max

      if total_domains.zero? || domains.compact_blank.size != total_domains
        errors.add(:domains, :blank)
        return
      end

      (0...total_domains).each do |i|
        if ClientDomain.exists?(domain: domains[i], port: ports[i])
          errors.add(:domains, :taken)
          break
        end
      end
    end

    def validate_ports
      total_ports = [domains.size, ports.size].max

      if total_ports.zero? || ports.compact_blank.size != total_ports
        errors.add(:ports, :blank)
        return
      end

      return if ports.all? { |port| /\A\d+\Z/.match?(port) }

      errors.add(:ports, :invalid)
    end
  end
end
