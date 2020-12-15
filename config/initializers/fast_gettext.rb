# frozen_string_literal: true

FastGettext.add_text_domain 'app', path: Rails.root.join('config/locales'), type: :po
FastGettext.default_available_locales = Rails.configuration.tenants.values.map { |t| t[:locales].keys }.flatten.uniq
FastGettext.default_text_domain = 'app'
