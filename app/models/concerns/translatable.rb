# frozen_string_literal: true

# Concern for adding translation functionality to models
module Translatable
  extend ActiveSupport::Concern

  included do
    has_many :translations, as: :translatable, dependent: :destroy, inverse_of: :translatable
  end

  def save_translation(locale)
    validate
    errors.attribute_names.each do |attribute|
      errors.delete(attribute, :blank)
      errors.delete(attribute, :taken)
    end

    return false if errors.any?

    !!ActiveRecord::Base.transaction do
      translation = translations.find_or_initialize_by(locale: locale.to_s)
      translation.fields = attributes.slice(*self.class::TRANSLATABLE_FIELDS)

      raise ActiveRecord::Rollback unless translation.save

      reload

      index if respond_to?(:index) || self.class.private_method_defined?(:index)
      index_associations if respond_to?(:index_associations) || self.class.private_method_defined?(:index_associations)

      true
    end
  end

  def translate(locale, use_defaults: false)
    model = dup
    translation = translations.detect { |t| t.locale == locale.to_s }

    self.class::TRANSLATABLE_FIELDS.each do |field|
      field_translation = translation&.fields.try(:[], field)
      model[field] = field_translation if field_translation.present? || !use_defaults
    end

    model
  end
end
