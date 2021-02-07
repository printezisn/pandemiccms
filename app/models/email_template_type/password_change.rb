# frozen_string_literal: true

module EmailTemplateType
  # Email template model for password change
  class PasswordChange < EmailTemplate
    def type_name
      _('Password Change')
    end
  end
end
