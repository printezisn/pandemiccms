# frozen_string_literal: true

module EmailTemplateType
  # Email template model for password change
  class PasswordChange < EmailTemplate
    def type_name
      _('Password Change')
    end

    def parameters
      {
        '{user.fullname}' => _('The user\'s full name.'),
        '{user.username}' => _('The user\'s name.'),
        '{user.email}' => _('The user\'s email address.')
      }
    end

    def send_test_email(admin_user)
      AuthMailer.password_change(admin_user).deliver
    end
  end
end
