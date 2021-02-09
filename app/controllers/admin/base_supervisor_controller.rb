# frozen_string_literal: true

module Admin
  # Base controller class for pages which require supervisor access
  class BaseSupervisorController < BaseController
    before_action :require_supervisor

    private

    def require_supervisor
      redirect_to admin_root_path unless current_admin_user.supervisor?
    end
  end
end
