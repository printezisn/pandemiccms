# frozen_string_literal: true

module Admin
  # Admin posts controller
  class PostsController < BaseController
    PAGE_SIZE = 10

    # GET /posts
    # GET /tag/:tag_id/posts
    # GET /user/:user_id/posts
    # GET /category/:category_id/posts
    def index
      @posts = Post.where(client_id: current_client.id)
      @posts = @posts.joins(:tag_taggables).where(tag_taggables: { tag_id: params[:tag_id] }) if params[:tag_id].present?
      if params[:category_id].present?
        @posts = @posts.joins(:category_categorizables).where(category_categorizables: { category_id: params[:category_id] })
      end
      # @posts = @posts.where(creator_id: params[:user_id]) if params[:user_id].present?

      @posts = @posts.simple_text_search(params[:search])
                     .bound_sort(params[:sort_by], params[:dir])
                     .page(params[:page].to_i)
                     .per(PAGE_SIZE)
      render :_posts_table, layout: nil if request.xhr?
    end
  end
end
