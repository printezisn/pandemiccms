# frozen_string_literal: true

require 'rails_helper'
require './spec/models/email_template_type/shared_spec'

RSpec.describe EmailTemplateType::AccountConfirmation, type: :model do
  subject(:model) { FactoryBot.build(:email_template, type: described_class.name).becomes(described_class) }

  describe '#type_name' do
    it { expect(model.type_name).to eq('Account Confirmation') }
  end

  it_behaves_like 'EmailTemplate'
end