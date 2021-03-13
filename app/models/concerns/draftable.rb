# frozen_string_literal: true

# Concern for adding draft/publish functionality to models
module Draftable
  extend ActiveSupport::Concern

  included do
    enum status: {
      draft: 0,
      published: 1
    }

    def publish_now
      return false if published?

      update(status: :published, published_at: Time.now.utc)
    end
  end
end
