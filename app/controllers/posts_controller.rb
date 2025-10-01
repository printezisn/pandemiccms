# frozen_string_literal: true

# Posts controller
class PostsController < ApplicationController
  include PathHelper

  # GET /p/1/slug
  def show
    @model = if params[:id].present?
               @tp.posts.find(params[:id])
             else
               @tp.posts.find_by!(slug: params[:slug])
             end

    slug = @tp.t(@model).slug
    return redirect_to template_entity_path(@model), status: :moved_permanently if slug != params[:slug]

    render "templates/#{current_client.template}/posts/#{@model.template.presence || 'default'}"
  end
end
