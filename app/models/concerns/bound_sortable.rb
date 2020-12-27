# frozen_string_literal: true

# Concern which adds bound sorting capabilities to models
module BoundSortable
  extend ActiveSupport::Concern

  included do
    sortable_fields = self::SORTABLE_FIELDS

    scope :bound_sort, lambda { |field, dir|
      field = sortable_fields.first unless sortable_fields.include?(field&.to_sym)
      order(field => dir == 'desc' ? :desc : :asc, id: :asc)
    }
  end
end
