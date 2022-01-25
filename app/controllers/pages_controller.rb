# frozen_string_literal: true

# Pages controller
class PagesController < ApplicationController
  # GET /
  def index
    @model = @tp.pages.find_by!(template: 'index').decorate

    render "templates/#{current_client.template}/pages/#{@model.template}"
  end

  # GET /pg/1/slug
  def show
    @model = @tp.pages.find(params[:id]).decorate

    slug = @tp.t(@model).displayed_slug(current_language&.transliterations)
    return redirect_to page_path(id: @model.id, slug:), status: :moved_permanently if slug != params[:slug]

    render "templates/#{current_client.template}/pages/#{@model.template.presence || 'default'}"
  end
end
