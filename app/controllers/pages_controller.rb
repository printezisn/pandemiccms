# frozen_string_literal: true

# Pages controller
class PagesController < ApplicationController
  def index
    render "templates/#{current_client.template}/pages/templates/index"
  end
end
