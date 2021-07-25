# frozen_string_literal: true

# Tags controller
class TagsController < ApplicationController
  # GET /t/1/slug
  def show
    render "templates/#{current_client.template}/tags/default"
  end
end
