# frozen_string_literal: true

# Pages controller
class PagesController < ApplicationController
  # GET /
  def index
    @model = Page.includes(:translations).find_by!(client_id: current_client.id, template: 'index').decorate
    raise ActionController::RoutingError, 'Not Found' if !@model.visible? && current_admin_user.nil?

    @translated_model = @model.translate(current_locale, use_defaults: true)

    render "templates/#{current_client.template}/pages/#{@model.template}"
  end

  # GET /pg/1/slug
  def show
    @model = Page.includes(:translations).find_by!(client_id: current_client.id, id: params[:id]).decorate
    raise ActionController::RoutingError, 'Not Found' if !@model.visible? && current_admin_user.nil?

    @translated_model = @model.translate(current_locale, use_defaults: true)

    slug = @translated_model.displayed_slug(current_language&.transliterations)
    return redirect_to page_path(id: @model.id, slug: slug), status: :moved_permanently if slug != params[:slug]

    render "templates/#{current_client.template}/pages/#{@model.template}"
  end
end
