# frozen_string_literal: true

module Admin
  # Admin dashboard controller
  class DashboardController < BaseController
    def index
      @media_count = Medium.where(client_id: current_client.id).count
      @tags_count = Tag.where(client_id: current_client.id).count
    end
  end
end
