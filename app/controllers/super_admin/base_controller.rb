# frozen_string_literal: true

module SuperAdmin
  # Base super admin controller
  class BaseController < ApplicationController
    http_basic_authenticate_with(
      name: Rails.application.credentials.super_admin[:username].to_s,
      password: Rails.application.credentials.super_admin[:password].to_s
    )

    def check_client_existence; end
    def verify_current_admin_user; end
    def set_theme_presenter; end

    def set_time_zone
      Time.zone = 'UTC'
    end

    def current_locale
      I18n.default_locale
    end

    def layout
      'super_admin'
    end

    def default_url_options
      { locale: current_locale }
    end
  end
end
