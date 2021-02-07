# frozen_string_literal: true

module EmailTemplateType
  # Email template model for reset password instructions
  class ResetPasswordInstructions < EmailTemplate
    def type_name
      _('Reset Password Instructions')
    end
  end
end
