# frozen_string_literal: true

module SearchIndex
  module Elastic
    # Base repository class for storing entities in elasticsearch
    class BaseRepository
      include Elasticsearch::Persistence::Repository

      attr_reader :client_id, :locale

      def model_type
        raise NotImplementedError
      end

      def klass
        raise NotImplementedError
      end

      def index_name
        "#{model_type}_#{client_id}_#{locale}_#{Rails.env}".downcase
      end

      def client
        Elasticsearch::Client.new(
          url: Rails.application.config.search[:url],
          log: Rails.env.development?,
          user: Rails.application.config.search[:username],
          password: Rails.application.config.search[:password]
        )
      end

      def initialize(client_id, locale)
        super({})

        @client_id = client_id
        @locale = locale
      end

      def find_matching_ids(text)
        search(
          query: {
            multi_match: {
              query: text.to_s,
              fuzziness: 'AUTO'
            }
          },
          size: 1000
        ).to_a.map { |post| post.attributes['id'] }
      end

      def total_entries
        search(query: { match_all: {} }).response[:hits][:total][:value]
      end
    end
  end
end
