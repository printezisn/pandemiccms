# frozen_string_literal: true

FastGettext.add_text_domain 'app', path: Rails.root.join('config/locales'), type: :po
FastGettext.available_locales = %w[en_GB el_GR]
FastGettext.default_text_domain = 'app'

I18n.available_locales = FastGettext.available_locales.map { |locale| locale.tr('_', '-') }
I18n.default_locale = I18n.available_locales.first
