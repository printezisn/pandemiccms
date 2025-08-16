# frozen_string_literal: true

# Helper methods for generating paths and URLs
module PathHelper
  def template_entity_path(entity, parameters = {})
    template_entity_url_or_path_for(entity, :path, parameters)
  end

  def template_entity_url(entity, parameters = {})
    template_entity_url_or_path_for(entity, :url, parameters)
  end

  def template_root_path(parameters = {})
    template_entity_path(Page.new(template: 'index'), parameters)
  end

  def template_root_url(parameters = {})
    template_entity_url(Page.new(template: 'index'), parameters)
  end

  private

  def template_entity_url_or_path_for(entity, type, parameters)
    if entity.is_a?(::MenuItem)
      return entity.external_url unless entity.linkable

      entity = entity.linkable
    end
    route = if entity.is_a?(::Page) && entity.template == 'index'
              'root'
            else
              "#{current_client.template}_#{entity.class.to_s.downcase}"
            end
    route_params = Rails.application.routes.routes.find { |r| r.name == route }.path.names

    all_params = parameters.clone
    locale = parameters[:locale]
    locale = current_locale if locale.nil? && current_client.enabled_languages.size > 1
    translated_entity = entity.translate(locale, use_defaults: true)
    route_params.each do |param|
      all_params[param.to_sym] = if param == 'id'
                                   entity.id
                                 elsif param == 'locale'
                                   locale
                                 elsif translated_entity.respond_to?(param)
                                   translated_entity.send(param)
                                 end
    end

    all_params.merge!(current_client.default_url_options) if type == :url

    Rails.application.routes.url_helpers.send("#{route}_#{type}", all_params)
  end
end
