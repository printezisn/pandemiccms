# frozen_string_literal: true

module Ahoy
  # Ahoy event model
  class Event < ApplicationRecord
    TEXT_SEARCHABLE_FIELDS = %i[properties].freeze
    SORTABLE_FIELDS = %i[count_all count_all].freeze

    include Ahoy::QueryMethods
    include BoundSortable
    include SimpleTextSearchable

    self.table_name = 'ahoy_events'

    belongs_to :client
    belongs_to :visit
    belongs_to :user, optional: true

    serialize :properties, coder: JSON
  end
end
