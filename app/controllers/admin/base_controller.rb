# frozen_string_literal: true

module Admin
  # Base admin controller
  class BaseController < ::ApplicationController
    before_action :authenticate_admin_user!

    helper_method :translation_locale
    helper_method :translation_language

    def layout
      'admin'
    end

    def translation_locale
      @translation_locale ||= translation_language&.locale || I18n.locale
    end

    def translation_language
      @translation_language ||=
        current_client.enabled_languages.detect { |l| l.locale == params[:translation_locale] } ||
        current_client.default_language
    end
  end
end
