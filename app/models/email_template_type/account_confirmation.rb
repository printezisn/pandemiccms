# frozen_string_literal: true

module EmailTemplateType
  # Email template model for account confirmation
  class AccountConfirmation < EmailTemplate
    def type_name
      _('Account Confirmation')
    end
  end
end
