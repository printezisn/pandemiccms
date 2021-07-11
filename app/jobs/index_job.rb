# frozen_string_literal: true

# Job which indexes an object to Elasticsearch
class IndexJob < ApplicationJob
  queue_as :default
  retry_on ActiveRecord::StaleObjectError

  def perform(*args)
    entity_klass = args[0].to_s.constantize
    search_entity_klass = "Elastic::#{args[0]}".constantize
    entity = entity_klass.find(args[1])

    repo_klass = "Elastic::#{entity_klass}Repository".constantize

    Language.pluck(:locale).each do |locale|
      search_entity = search_entity_klass.from_entity(locale, entity)

      repo = repo_klass.new(entity.client_id, locale)
      repo.save(search_entity)
    end

    total_updated = entity_klass.where(id: entity.id, index_version: entity.index_version)
                                .update_all(
                                  indexed_at: Time.now.utc,
                                  index_version: SecureRandom.uuid,
                                  updated_at: Time.now.utc
                                )
    raise ActiveRecord::StaleObjectError if total_updated.zero?
  end
end
