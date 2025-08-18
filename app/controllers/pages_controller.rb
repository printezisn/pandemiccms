# frozen_string_literal: true

# Pages controller
class PagesController < ApplicationController
  include PathHelper
  include Trackable

  # GET /
  def index
    @model = @tp.pages.find_by!(template: 'index')

    track_page_visit

    render "templates/#{current_client.template}/pages/#{@model.template}"
  end

  # GET /pg/1/slug
  def show
    @model = if params[:id].present?
               @tp.pages.find(params[:id])
             else
               @tp.pages.find_by!(slug: params[:slug])
             end

    slug = @tp.t(@model).slug
    return redirect_to template_entity_path(@model), status: :moved_permanently if slug != params[:slug]

    track_page_visit

    render "templates/#{current_client.template}/pages/#{@model.template.presence || 'default'}"
  end
end
