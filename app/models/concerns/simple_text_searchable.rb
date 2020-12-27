# frozen_string_literal: true

# Concern which adds simple text search to models
module SimpleTextSearchable
  extend ActiveSupport::Concern

  included do
    text_searchable_fields = self::TEXT_SEARCHABLE_FIELDS

    scope :simple_text_search, lambda { |term|
      where_condition = nil

      text_searchable_fields.each do |field|
        term_condition = arel_table[field].matches("%#{term}%")
        where_condition = if where_condition
                            where_condition.or(term_condition)
                          else
                            term_condition
                          end
      end

      where(where_condition)
    }
  end
end
