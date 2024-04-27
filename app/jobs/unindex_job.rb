# frozen_string_literal: true

# Job which unindexes an object from search index
class UnindexJob < ApplicationJob
  queue_as :default

  def perform(*args)
    entity_klass = args[0].to_s.constantize
    client_id = args[1]
    entity_id = args[2]

    repo_klass = SearchIndex::RepositoryFactory.get(entity_klass)

    Language.pluck(:locale).each do |locale|
      repo = repo_klass.new(client_id, locale)
      repo.delete(entity_id)
    end
  end
end
