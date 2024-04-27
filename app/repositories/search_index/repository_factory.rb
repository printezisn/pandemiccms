# frozen_string_literal: true

module SearchIndex
  # factory class for search index repositories
  class RepositoryFactory
    def self.get(entity_klass)
      "::SearchIndex::Elastic::#{entity_klass}Repository".constantize
    end
  end
end
