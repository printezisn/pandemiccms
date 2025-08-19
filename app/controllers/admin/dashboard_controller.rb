# frozen_string_literal: true

module Admin
  # Admin dashboard controller
  class DashboardController < BaseController
    PAGE_SIZE = 10

    def index
      @media_count = Medium.where(client_id: current_client.id).count
      @tags_count = Tag.where(client_id: current_client.id).count
      @categories_count = Category.where(client_id: current_client.id).count
      @users_count = AdminUser.where(client_id: current_client.id, status: :active).count if current_admin_user.supervisor?
      @pages_count = Page.where(client_id: current_client.id).count
      @draft_pages_count = Page.draft.where(author_id: current_admin_user.id).count
      @posts_count = Post.where(client_id: current_client.id).count
      @draft_posts_count = Post.draft.where(author_id: current_admin_user.id).count
      @menus_count = Menu.where(client_id: current_client.id).count
      @contents_count = Content.where(client_id: current_client.id).count
    end

    def page_visits
      @page_visits = Ahoy::Event.where(client_id: current_client.id, name: 'Page Visit', time: 1.month.ago.to_date...)
                                .simple_text_search(params[:search])
      @visits_by_date = @page_visits.group_by_day(:time).count
      @chart_data = {}
      (1.month.ago.to_date..Time.zone.now.to_date).each do |date|
        @chart_data[date] = @visits_by_date[date] || 0
      end
      @page_visits = @page_visits.group(:properties)
                                 .bound_sort(params[:sort_by], params[:dir] || 'desc')
                                 .select(:properties, 'COUNT(*) AS count_all')
                                 .page(params[:page].to_i)
                                 .per(PAGE_SIZE)

      render 'page_visits', layout: nil
    end
  end
end
