# frozen_string_literal: true

module Admin
  # Admin controller for handling cache-related operations
  class CacheController < BaseController
    before_action :require_supervisor

    # POST /clear
    def clear
      CacheVersionBumper.call(current_client.id)
      redirect_to admin_root_path, notice: _('The cache was successfully cleared.')
    end
  end
end
