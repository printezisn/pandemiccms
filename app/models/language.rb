# frozen_string_literal: true

# Language model
class Language < ApplicationRecord
  has_many :client_languages, inverse_of: :language, dependent: :destroy
end
