# frozen_string_literal: true

# Tags controller
class TagsController < ApplicationController
  include PathHelper

  # GET /t/1/slug
  def show
    @model = @tp.tags.find(params[:id])

    slug = @tp.t(@model).slug
    return redirect_to template_entity_path(@model), status: :moved_permanently if slug != params[:slug]

    render "templates/#{current_client.template}/tags/#{@model.template.presence || 'default'}"
  end
end
