# frozen_string_literal: true

# Pages controller
class PagesController < ApplicationController
  include PathHelper

  # GET /
  def index
    @model = @tp.pages.find_by!(template: 'index')

    render "templates/#{current_client.template}/pages/#{@model.template}"
  end

  # GET /pg/1/slug
  def show
    @model = @tp.pages.find(params[:id])

    slug = @tp.t(@model).slug
    return redirect_to template_entity_path(@model), status: :moved_permanently if slug != params[:slug]

    render "templates/#{current_client.template}/pages/#{@model.template.presence || 'default'}"
  end
end
