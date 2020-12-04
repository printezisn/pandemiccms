# frozen_string_literal: true

class ClientLanguage < ApplicationRecord
  belongs_to :client, inverse_of: :client_languages
  belongs_to :language, inverse_of: :client_languages
end
