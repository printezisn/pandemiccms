# frozen_string_literal: true

# Job which deletes old visits and events
class DeleteOldEventsJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    Ahoy::Visit.where(started_at: ...1.month.ago).find_in_batches do |visits|
      visit_ids = visits.map(&:id)
      Ahoy::Event.where(visit_id: visit_ids).delete_all
      Ahoy::Visit.where(id: visit_ids).delete_all
    end
  end
end
