# frozen_string_literal: true

module EmailTemplateType
  # Email template model for reset password instructions
  class ResetPasswordInstructions < EmailTemplate
    def type_name
      _('Reset Password Instructions')
    end

    def parameters
      {
        '{user.fullname}' => _('The user\'s full name.'),
        '{user.username}' => _('The user\'s name.'),
        '{user.email}' => _('The user\'s email address.'),
        '{user.reset_password_token}' => _('The reset password token.')
      }
    end
  end
end
