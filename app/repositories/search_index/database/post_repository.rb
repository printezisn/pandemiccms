# frozen_string_literal: true

module SearchIndex
  module Database
    # Repository class storing indexed posts in database
    class PostRepository
      attr_reader :client_id, :locale

      def initialize(client_id, locale)
        @client_id = client_id
        @locale = locale
      end

      def save(entity)
        h = entity.to_hash
        tokens = [h[:name], h[:description], h[:body]] +
                 (h[:categories] || []).pluck(:name) +
                 (h[:tags] || []).pluck(:name)
        text = tokens.join(' ')

        indexed_entity = ::IndexedEntity.find_or_initialize_by(indexable_id: h[:id], indexable_type: ::Post.to_s, locale:)
        indexed_entity.text = text
        indexed_entity.save!
      end

      def delete(entity_id)
        indexed_entity = ::IndexedEntity.find_by(indexable_id: entity_id, indexable_type: ::Post.to_s, locale:)
        indexed_entity&.destroy!
      end

      def find_matching_ids(text)
        condition = ::IndexedEntity.arel_table[:text].matches("%#{text}%")
        ::IndexedEntity.where(condition).pluck(:indexable_id)
      end

      def total_entries
        ::IndexedEntity.where(locale:).count
      end
    end
  end
end
