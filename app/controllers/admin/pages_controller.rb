# frozen_string_literal: true

module Admin
  # Admin pages controller
  class PagesController < BaseController
    PAGE_SIZE = 10

    # GET /pages
    # GET /tag/:tag_id/pages
    # GET /user/:user_id/pages
    def index
      @pages = Page.where(client_id: current_client.id)
      @pages = @pages.joins(:tag_taggables).where(tag_taggables: { tag_id: params[:tag_id] }) if params[:tag_id].present?
      # @pages = @pages.where(creator_id: params[:user_id]) if params[:user_id].present?

      @pages = @pages.simple_text_search(params[:search])
                     .bound_sort(params[:sort_by], params[:dir])
                     .page(params[:page].to_i)
                     .per(PAGE_SIZE)
      render :_pages_table, layout: nil if request.xhr?
    end
  end
end
