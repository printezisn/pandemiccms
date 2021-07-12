# frozen_string_literal: true

# Job which indexes all entities to Elasticsearch
class IndexAllJob < ApplicationJob
  MODEL_TYPES = [Post].freeze

  queue_as :default

  def perform(*args)
    MODEL_TYPES.each do |model_type|
      entities = model_type.all
      entities = entities.where(client_id: args[0]) if args[0].present?
      entities = entities.where(indexed_at: nil) if args[1].present?

      entities.find_each { |entity| IndexJob.perform_later(entity.class, entity.id) }
    end
  end
end
