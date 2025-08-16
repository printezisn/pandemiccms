# frozen_string_literal: true

# Class to hold current request values
class Current < ActiveSupport::CurrentAttributes
  attribute :client

  def fetch_client(request)
    self.client ||= begin
      domain = [request.subdomain, request.domain].filter_map(&:presence).join('.')

      Client.joins(:client_domains)
            .find_by(client_domains: { domain:, port: request.port })
            &.decorate
    end
  end
end
