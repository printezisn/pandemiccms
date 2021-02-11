# frozen_string_literal: true

module EmailTemplateType
  # Email template model for email change
  class EmailChange < EmailTemplate
    def type_name
      _('Email Change')
    end

    def parameters
      {
        '{user.fullname}' => _('The user\'s full name.'),
        '{user.username}' => _('The user\'s name.'),
        '{user.email}' => _('The user\'s email address.'),
        '{user.unconfirmed_email}' => _('The user\'s unconfirmed email address.')
      }
    end
  end
end
