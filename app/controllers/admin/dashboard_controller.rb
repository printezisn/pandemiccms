# frozen_string_literal: true

module Admin
  # Admin dashboard controller
  class DashboardController < BaseController
    def index
      @media_count = Medium.where(client_id: current_client.id).count
      @tags_count = Tag.where(client_id: current_client.id).count
      @categories_count = Category.where(client_id: current_client.id).count
      @users_count = AdminUser.where(client_id: current_client.id, status: :active).count if current_admin_user.supervisor?
      @pages_count = Page.where(client_id: current_client.id).count
      @draft_pages_count = Page.draft.where(author_id: current_admin_user.id).count
    end
  end
end
