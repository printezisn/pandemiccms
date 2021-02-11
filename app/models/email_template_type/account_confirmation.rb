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
        '{user.confirmation_token}' => _('The account confirmation token.')
      }
    end
  end
end
