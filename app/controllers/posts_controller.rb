# frozen_string_literal: true

# Posts controller
class PostsController < ApplicationController
  # GET /p/1/slug
  def show
    render "templates/#{current_client.template}/posts/templates/default"
  end
end
