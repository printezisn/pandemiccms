# frozen_string_literal: true

# Client domain model
class ClientDomain < ApplicationRecord
  belongs_to :client, inverse_of: :client_domains

  def url_options
    {
      host: domain,
      port:,
      protocol: port == 443 ? 'https' : 'http'
    }
  end
end
