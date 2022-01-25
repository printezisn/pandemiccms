# frozen_string_literal: true

# Tags controller
class TagsController < ApplicationController
  # GET /t/1/slug
  def show
    @model = @tp.tags.find(params[:id]).decorate

    slug = @tp.t(@model).displayed_slug(current_language&.transliterations)
    return redirect_to tag_path(id: @model.id, slug:), status: :moved_permanently if slug != params[:slug]

    render "templates/#{current_client.template}/tags/#{@model.template.presence || 'default'}"
  end
end
