# frozen_string_literal: true

# Tags controller
class TagsController < ApplicationController
  # GET /t/1/slug
  def show
    @model = CacheFetcher.call(current_client, current_cache_version, ['tag', params[:id]]) do
      Tag.includes(:translations).find_by!(client_id: current_client.id, id: params[:id])
    end
    raise ActionController::RoutingError, 'Not Found' if @model.private_visibility? && current_admin_user.nil?

    @translated_model = @model.translate(current_locale, use_defaults: true)

    slug = @translated_model.displayed_slug(current_language&.transliterations)
    return redirect_to tag_path(id: @model.id, slug: slug) if slug != params[:slug]

    render "templates/#{current_client.template}/tags/#{@model.template}"
  end
end
