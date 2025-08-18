# frozen_string_literal: true

# Concern to add page tracking capabilities
module Trackable
  private

  def track_page_visit
    ahoy.track 'Page Visit', request.fullpath
  end
end
