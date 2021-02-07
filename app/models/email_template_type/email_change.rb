# frozen_string_literal: true

module EmailTemplateType
  # Email template model for email change
  class EmailChange < EmailTemplate
    def type_name
      _('Email Change')
    end
  end
end
