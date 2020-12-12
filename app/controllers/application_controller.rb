# frozen_string_literal: true

# Base application controller
class ApplicationController < ActionController::Base
  before_action :set_gettext_locale

  helper_method :current_client

  layout :layout

  def current_client
    @current_client ||= Rails.configuration.tenants.values.detect { |tenant| tenant[:domains].include?(request.domain) }
  end

  def layout
    devise_controller? ? 'admin' : 'application'
  end
end
