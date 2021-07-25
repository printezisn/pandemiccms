# frozen_string_literal: true

# Categories controller
class CategoriesController < ApplicationController
  # GET /c/1/slug
  def show
    render "templates/#{current_client.template}/categories/default"
  end
end
