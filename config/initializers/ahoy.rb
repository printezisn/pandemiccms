# frozen_string_literal: true

module Ahoy
  # Database store for Ahoy visits and events
  class Store < Ahoy::DatabaseStore
    def authenticate(data); end
  end
end

# set to true for JavaScript tracking
Ahoy.api = false

# set to true for geocoding (and add the geocoder gem to your Gemfile)
# we recommend configuring local geocoding as well
# see https://github.com/ankane/ahoy#geocoding
Ahoy.geocode = false

Ahoy.mask_ips = true
Ahoy.cookies = :none
Ahoy.track_bots = true if Rails.env.test? # always track bots in test environment
