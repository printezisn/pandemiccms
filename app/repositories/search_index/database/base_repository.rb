# frozen_string_literal: true

module SearchIndex
  module Database
    # Base repository class storing indexed entities in database
    class BaseRepository
      attr_reader :client_id, :locale

      def initialize(client_id, locale)
        @client_id = client_id
        @locale = locale
      end

      def save(entity)
        h = tokens(entity)

        indexed_entity = ::IndexedEntity.find_or_initialize_by(indexable_id: h[:id], indexable_type: klass.to_s, client_id:, locale:)
        indexed_entity.text = h[:text]
        indexed_entity.save!
      end

      def delete(entity_id)
        indexed_entity = ::IndexedEntity.find_by(indexable_id: entity_id, indexable_type: klass.to_s, locale:)
        indexed_entity&.destroy!
      end

      def find_matching_ids(text)
        condition = ::IndexedEntity.arel_table[:text].matches("%#{text}%")
        ::IndexedEntity.where(client_id:, locale:, indexable_type: klass.to_s).where(condition).pluck(:indexable_id)
      end

      def total_entries
        ::IndexedEntity.where(client_id:, locale:, indexable_type: klass.to_s).count
      end

      protected

      def klass
        raise NotImplementedError
      end

      def tokens(entity)
        raise NotImplementedError
      end
    end
  end
end
