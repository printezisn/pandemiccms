# frozen_string_literal: true

# Categories controller
class CategoriesController < ApplicationController
  include PathHelper

  # GET /c/1/slug
  def show
    @model = if params[:id].present?
               @tp.categories.find(params.expect(:id))
             else
               @tp.categories.find_by!(slug: params.expect(:slug))
             end

    slug = @tp.t(@model).slug
    return redirect_to template_entity_path(@model), status: :moved_permanently if slug != params[:slug]

    render "templates/#{current_client.template}/categories/#{@model.template.presence || 'default'}"
  end
end
