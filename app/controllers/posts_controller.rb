# frozen_string_literal: true

# Posts controller
class PostsController < ApplicationController
  # GET /p/1/slug
  def show
    @model = CacheFetcher.call(current_client, current_cache_version, ['post', params[:id]]) do
      Post.includes(:translations).find_by!(client_id: current_client.id, id: params[:id])
    end
    raise ActionController::RoutingError, 'Not Found' if !@model.visible? && current_admin_user.nil?

    @translated_model = @model.translate(current_locale, use_defaults: true)

    slug = @translated_model.displayed_slug(current_language&.transliterations)
    return redirect_to post_path(id: @model.id, slug: slug) if slug != params[:slug]

    render "templates/#{current_client.template}/posts/#{@model.template}"
  end
end
