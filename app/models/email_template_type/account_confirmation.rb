# frozen_string_literal: true

module EmailTemplateType
  # Email template model for account confirmation
  class AccountConfirmation < EmailTemplate
    def type_name
      _('Account Confirmation')
    end

    def parameters
      {
        '{user.fullname}' => _('The user\'s full name.'),
        '{user.username}' => _('The user\'s name.'),
        '{user.email}' => _('The user\'s email address.'),
        '{user.confirmation_link}' => _('The account confirmation link.')
      }
    end

    def send_test_email(admin_user)
      AuthMailer.confirmation_instructions(admin_user, '1234').deliver
    end
  end
end
