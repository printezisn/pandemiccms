# frozen_string_literal: true

module SearchIndex
  module Database
    # Repository class storing indexed posts in database
    class PostRepository < BaseRepository
      protected

      def klass
        ::Post
      end

      def tokens(entity)
        h = entity.to_hash
        tokens = [h[:name], h[:description], h[:body]] +
                 (h[:categories] || []).pluck(:name) +
                 (h[:tags] || []).pluck(:name)

        { id: h[:id], text: tokens.join(' ') }
      end
    end
  end
end
