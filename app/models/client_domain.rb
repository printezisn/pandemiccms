# frozen_string_literal: true

class ClientDomain < ApplicationRecord
  belongs_to :client, inverse_of: :client_domains
end
