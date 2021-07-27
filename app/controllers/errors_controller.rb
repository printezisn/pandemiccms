# frozen_string_literal: true

# Controller with custom error handling
class ErrorsController < ApplicationController
  def not_found
    @model = CacheFetcher.call(current_client, current_cache_version, 'not_found_page') do
      Page.includes(:translations).find_by(client_id: current_client.id, template: 'not_found')
    end
    if @model.nil? || (@model.draft? && current_admin_user.nil?)
      return render file: Rails.root.join('public/404.html'),
                    layout: false,
                    status: :not_found
    end

    @translated_model = @model.translate(current_locale, use_defaults: true)

    render "templates/#{current_client.template}/pages/#{@model.template}", status: :not_found
  end

  def internal_server_error
    @model = CacheFetcher.call(current_client, current_cache_version, 'internal_server_error_page') do
      Page.includes(:translations).find_by(client_id: current_client.id, template: 'internal_error')
    end
    if @model.nil? || (@model.draft? && current_admin_user.nil?)
      return render file: Rails.root.join('public/500.html'),
                    layout: false,
                    status: :not_found
    end

    @translated_model = @model.translate(current_locale, use_defaults: true)

    render "templates/#{current_client.template}/pages/#{@model.template}", status: :internal_server_error
  end
end
