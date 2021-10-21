# frozen_string_literal: true

require 'uri'

# Client model
class Client < ApplicationRecord
  DEFAULT_EMAIL = 'admin@pandemiccms.com'

  include Imageable

  has_many :client_languages, inverse_of: :client, dependent: :destroy
  has_many :languages, through: :client_languages
  has_many :client_domains, inverse_of: :client, dependent: :destroy
  has_many :admin_users, inverse_of: :client, dependent: :destroy
  has_many :media, inverse_of: :client, dependent: :destroy
  has_many :tags, inverse_of: :client, dependent: :destroy
  has_many :posts, inverse_of: :client, dependent: :destroy
  has_many :pages, inverse_of: :client, dependent: :destroy
  has_many :email_templates, inverse_of: :client, dependent: :destroy
  has_many :categories, inverse_of: :client, dependent: :destroy
  has_many :menus, inverse_of: :client, dependent: :destroy
  has_many :redirects, inverse_of: :client, dependent: :destroy

  validates :name, presence: true, length: { maximum: 255 }
  validates :email, length: { maximum: 255 }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, if: -> { email.present? }
  validates :cache_duration, presence: true, if: :cache_enabled?
  validate :valid_time_zone

  def default_url_options
    @default_url_options ||= {
      host: client_domains.first.domain,
      port: client_domains.first.port,
      protocol: client_domains.first.port == 443 ? 'https' : 'http'
    }
  end

  def enabled_client_languages
    @enabled_client_languages ||= client_languages.includes(:language).where(enabled: true)
  end

  def enabled_languages
    @enabled_languages ||= enabled_client_languages.map(&:language)
  end

  def default_language
    @default_language ||=
      enabled_client_languages.detect(&:default?)&.language ||
      enabled_client_languages.first&.language
  end

  private

  def valid_time_zone
    errors.add(:time_zone, :invalid) unless ActiveSupport::TimeZone[time_zone.to_s]
  end
end
