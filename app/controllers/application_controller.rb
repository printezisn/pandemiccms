# frozen_string_literal: true

# Base application controller
class ApplicationController < ActionController::Base
  before_action :set_gettext_locale

  helper_method :current_client_id

  layout :layout

  def current_client_id
    @current_client_id ||= Rails.configuration.tenants[request.domain]
  end

  def layout
    devise_controller? ? 'admin' : 'application'
  end
end
