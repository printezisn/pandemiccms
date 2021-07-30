# frozen_string_literal: true

# Posts controller
class PostsController < ApplicationController
  # GET /p/1/slug
  def show
    @model = Post.find_by!(client_id: current_client.id, id: params[:id]).decorate
    raise ActionController::RoutingError, 'Not Found' if !@model.visible? && current_admin_user.nil?

    @translated_model = @model.translate(current_locale, use_defaults: true)

    slug = @translated_model.displayed_slug(current_language&.transliterations)
    return redirect_to post_path(id: @model.id, slug: slug), status: :moved_permanently if slug != params[:slug]

    render "templates/#{current_client.template}/posts/#{@model.template.presence || 'default'}"
  end
end
