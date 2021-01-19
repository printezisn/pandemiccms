# frozen_string_literal: true

# Concern for adding translation functionality to models
module Translatable
  extend ActiveSupport::Concern

  included do
    has_many :translations, as: :translatable, dependent: :destroy
  end

  def save_translation(locale)
    return false unless valid?

    translation = translations.find_or_initialize_by(locale: locale.to_s)
    translation.fields = attributes.slice(*self.class::TRANSLATABLE_FIELDS)

    translation.save
  end

  def translate(locale, use_defaults: false)
    model = dup
    translation = translations.find_by(locale: locale.to_s)
    return model unless translation

    self.class::TRANSLATABLE_FIELDS.each do |field|
      model[field] = translation.fields[field] if translation.fields[field].present? || !use_defaults
    end

    model
  end
end
