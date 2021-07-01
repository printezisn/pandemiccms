# frozen_string_literal: true

# Job which indexes a post to Elasticsearch
class IndexPostJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
  end
end
