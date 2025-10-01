# frozen_string_literal: true

class AnalyticsController < ApplicationController
  # POST /analytics/track_visit
  def track_visit
    return if params[:path].blank?

    path = params[:path].strip[0..250]
    if current_visit
      event_exists = Ahoy::Event.exists?(client_id: current_client.id, visit_id: current_visit.id,
                                         name: 'Page Visit', properties: path)
      return if event_exists
    end

    ahoy.track 'Page Visit', path
  end
end
