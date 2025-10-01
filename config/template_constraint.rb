# frozen_string_literal: true

# This class is responsible for constraining routes based on the current client's template
class TemplateConstraint
  def initialize(template)
    @template = template
  end

  def matches?(request)
    return false if request.path.start_with?('/rails')

    Current.fetch_client(request)&.template == @template
  end
end
