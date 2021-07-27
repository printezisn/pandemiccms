# frozen_string_literal: true

# Pages controller
class PagesController < ApplicationController
  # GET /
  def index
    @model = CacheFetcher.call(current_client, current_cache_version, 'index_page') do
      Page.includes(:translations).find_by!(client_id: current_client.id, template: 'index')
    end
    raise ActionController::RoutingError, 'Not Found' if !@model.visible? && current_admin_user.nil?

    @translated_model = @model.translate(current_locale, use_defaults: true)

    render "templates/#{current_client.template}/pages/#{@model.template}"
  end

  # GET /pg/1/slug
  def show
    @model = CacheFetcher.call(current_client, current_cache_version, ['page', params[:id]]) do
      Page.includes(:translations).find_by!(client_id: current_client.id, id: params[:id])
    end
    raise ActionController::RoutingError, 'Not Found' if !@model.visible? && current_admin_user.nil?

    @translated_model = @model.translate(current_locale, use_defaults: true)

    slug = @translated_model.displayed_slug(current_language&.transliterations)
    return redirect_to page_path(id: @model.id, slug: slug), status: :moved_permanently if slug != params[:slug]

    render "templates/#{current_client.template}/pages/#{@model.template}"
  end
end
