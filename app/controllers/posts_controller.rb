# frozen_string_literal: true

# Posts controller
class PostsController < ApplicationController
  # GET /p/1/slug
  def show
    @model = @tp.posts.find(params[:id]).decorate

    slug = @tp.t(@model).displayed_slug(current_language&.transliterations)
    return redirect_to post_path(id: @model.id, slug:), status: :moved_permanently if slug != params[:slug]

    render "templates/#{current_client.template}/posts/#{@model.template.presence || 'default'}"
  end
end
