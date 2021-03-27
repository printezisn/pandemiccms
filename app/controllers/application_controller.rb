# frozen_string_literal: true

# Base application controller
class ApplicationController < ActionController::Base
  before_action :check_client_existence
  before_action :set_locale
  before_action :set_time_zone
  before_action :set_date_time_formats
  before_action :verify_current_admin_user

  helper_method :current_client
  helper_method :current_language
  helper_method :current_locale

  layout :layout

  def check_client_existence
    raise ActionController::RoutingError, 'Not Found' unless current_client
  end

  def set_locale
    FastGettext.set_locale(current_locale)
    I18n.locale = current_locale
  end

  def set_time_zone
    Time.zone = current_client.time_zone
  end

  def current_client
    @current_client ||= fetch_current_client
  end

  def current_language
    @current_language ||= fetch_current_language
  end

  def current_locale
    @current_locale ||= current_language&.locale || I18n.default_locale
  end

  def set_date_time_formats
    Date::DATE_FORMATS[:default] = _('date.formats.default')
    Time::DATE_FORMATS[:default] = _('time.formats.default')
  end

  def verify_current_admin_user
    return if !current_admin_user || current_admin_user.client_id == current_client.id

    sign_out(current_admin_user)
    redirect_to new_admin_user_session_path
  end

  def layout
    devise_controller? ? 'admin_auth' : 'application'
  end

  def default_url_options
    { locale: current_locale }
  end

  private

  def fetch_current_client
    Client.joins(:client_domains).find_by(client_domains: { domain: request.domain, port: request.port })
  end

  def fetch_current_language
    current_client.enabled_languages.detect { |l| l.locale == params[:locale] } ||
      current_client.default_language
  end
end
