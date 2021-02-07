# frozen_string_literal: true

# Concern for adding translation functionality to models
module Translatable
  extend ActiveSupport::Concern

  included do
    has_many :translations, as: :translatable, dependent: :destroy
  end

  def save_translation(locale)
    return false unless valid?

    !!ActiveRecord::Base.transaction do
      translation = translations.find_or_initialize_by(locale: locale.to_s)
      translation.fields = attributes.slice(*self.class::TRANSLATABLE_FIELDS)

      return unless translation.save

      if respond_to?(:updater_id)
        updater_id = self.updater_id
        reload
        raise ActiveRecord::Rollback unless update(updater_id: updater_id)
      else
        reload
      end

      true
    end
  end

  def translate(locale, use_defaults: false)
    model = dup
    translation = translations.find_by(locale: locale.to_s)

    self.class::TRANSLATABLE_FIELDS.each do |field|
      field_translation = translation&.fields.try(:[], field)
      model[field] = field_translation if field_translation.present? || !use_defaults
    end

    model
  end
end
