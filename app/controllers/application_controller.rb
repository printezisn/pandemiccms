# frozen_string_literal: true

# Base application controller
class ApplicationController < ActionController::Base
  before_action :set_locale
  before_action :set_time_zone

  helper_method :current_client
  helper_method :current_locale

  layout :layout

  def set_locale
    FastGettext.set_locale(current_locale)
    I18n.locale = current_locale
  end

  def set_time_zone
    Time.zone = current_client[:time_zone]
  end

  def current_client
    @current_client ||= Rails.configuration.tenants.values.detect { |tenant| tenant[:domains].include?(request.domain) }
  end

  def current_locale
    @current_locale ||= fetch_current_locale
  end

  def layout
    devise_controller? ? 'admin' : 'application'
  end

  def default_url_options
    { locale: current_locale }
  end

  private

  def fetch_current_locale
    return params[:locale].to_sym if params[:locale] && current_client[:locales].key?(params[:locale])

    current_client[:locales].keys.first || I18n.default_locale
  end
end
