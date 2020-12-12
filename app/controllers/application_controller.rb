# frozen_string_literal: true

# Base application controller
class ApplicationController < ActionController::Base
  before_action :set_locale

  helper_method :current_client
  helper_method :current_locale

  layout :layout

  def set_locale
    FastGettext.set_locale(current_locale)
    I18n.locale = current_locale
  end

  def current_client
    @current_client ||= Rails.configuration.tenants.values.detect { |tenant| tenant[:domains].include?(request.domain) }
  end

  def current_locale
    @current_locale ||= begin
      current_client[:locales].detect { |l| l == params[:locale] } ||
        current_client[:locales].first ||
        I18n.default_locale
    end
  end

  def layout
    devise_controller? ? 'admin' : 'application'
  end

  def default_url_options
    { locale: current_locale }
  end
end
