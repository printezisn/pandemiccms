# frozen_string_literal: true

available_locales = Rails.application.config.available_languages.pluck(:locale) + ['en']

FastGettext.add_text_domain 'app', path: Rails.root.join('config/locales'), type: :po
FastGettext.available_locales = available_locales.map { |locale| locale.tr('-', '_') }
FastGettext.default_text_domain = 'app'

I18n.available_locales = available_locales
I18n.default_locale = I18n.available_locales.first
