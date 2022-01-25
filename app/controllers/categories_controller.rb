# frozen_string_literal: true

# Categories controller
class CategoriesController < ApplicationController
  # GET /c/1/slug
  def show
    @model = @tp.categories.find(params[:id]).decorate

    slug = @tp.t(@model).displayed_slug(current_language&.transliterations)
    return redirect_to category_path(id: @model.id, slug:), status: :moved_permanently if slug != params[:slug]

    render "templates/#{current_client.template}/categories/#{@model.template.presence || 'default'}"
  end
end
