# frozen_string_literal: true

# Tags controller
class TagsController < ApplicationController
  # GET /t/1/slug
  def show
    @model = Tag.find_by!(client_id: current_client.id, id: params[:id]).decorate
    raise ActionController::RoutingError, 'Not Found' if @model.private_visibility? && current_admin_user.nil?

    @translated_model = @model.translate(current_locale, use_defaults: true)

    slug = @translated_model.displayed_slug(current_language&.transliterations)
    return redirect_to tag_path(id: @model.id, slug: slug), status: :moved_permanently if slug != params[:slug]

    render "templates/#{current_client.template}/tags/#{@model.template.presence || 'default'}"
  end
end
