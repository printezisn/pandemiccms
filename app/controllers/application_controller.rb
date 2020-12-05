# frozen_string_literal: true

# Base application controller
class ApplicationController < ActionController::Base
  helper_method :current_client_id

  def current_client_id
    @current_client_id ||= Rails.configuration.tenants[request.domain]
  end
end
