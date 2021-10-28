# frozen_string_literal: true

# Service class to initialize the language entries in the database
class LanguageInitializer < ApplicationService
  def call
    Rails.application.config.available_languages.each do |language_params|
      Language.create!(language_params) unless Language.exists?(locale: language_params[:locale])
    end
  end
end
