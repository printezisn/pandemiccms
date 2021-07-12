# frozen_string_literal: true

module Admin
  # Admin controller for handling search index-related operations
  class IndexController < BaseSupervisorController
    # POST /start
    def start
      IndexAllJob.perform_later(current_client.id, false)
      redirect_to admin_root_path, notice: _('The indexing process was successfully initiated.')
    end
  end
end
