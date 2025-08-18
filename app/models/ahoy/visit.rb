# frozen_string_literal: true

module Ahoy
  # Ahoy visit model
  class Visit < ApplicationRecord
    self.table_name = 'ahoy_visits'

    has_many :events, class_name: 'Ahoy::Event' # rubocop:disable Rails/HasManyOrHasOneDependent
    belongs_to :user, optional: true
  end
end
