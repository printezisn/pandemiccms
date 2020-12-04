# frozen_string_literal: true

# Client model
class Client < ApplicationRecord
  has_many :client_languages, inverse_of: :client, dependent: :destroy
  has_many :languages, through: :client_languages
  has_many :client_domains, inverse_of: :client, dependent: :destroy
  has_many :admin_users, inverse_of: :client, dependent: :destroy
  has_many :media, inverse_of: :client, dependent: :destroy

  def default_url_options
    {
      host: client_domains.first.domain,
      port: client_domains.first.port
    }
  end
end
