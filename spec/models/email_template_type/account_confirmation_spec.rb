# frozen_string_literal: true

require 'rails_helper'
require './spec/models/email_template_type/shared'

RSpec.describe EmailTemplateType::AccountConfirmation, type: :model do
  subject(:model) { build(:email_template, type: described_class.name).becomes(described_class) }

  describe '#type_name' do
    it { expect(model.type_name).to eq('Account Confirmation') }
  end

  describe '#parameters' do
    it 'returns the available parameters with description' do
      expect(model.parameters).to eq({
                                       '{user.fullname}' => 'The user\'s full name.',
                                       '{user.username}' => 'The user\'s name.',
                                       '{user.email}' => 'The user\'s email address.',
                                       '{user.confirmation_link}' => 'The account confirmation link.'
                                     })
    end
  end

  it_behaves_like 'EmailTemplate'
end
