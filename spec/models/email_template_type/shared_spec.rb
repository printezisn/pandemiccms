# frozen_string_literal: true

RSpec.shared_examples 'EmailTemplate' do
  subject(:model) { FactoryBot.build(:email_template, type: described_class.name) }

  it { is_expected.to belong_to(:client) }

  it { is_expected.to validate_presence_of(:subject).with_message('The subject is required.') }
  it { is_expected.to validate_length_of(:subject).is_at_most(255).with_message('The subject may contain up to 255 characters.') }
  it { is_expected.to validate_presence_of(:body).with_message('The body is required.') }

  describe 'concerns' do
    let(:translation) { FactoryBot.build(:email_template, type: described_class.name) }

    before { model.save! }

    it_behaves_like 'Translatable'
  end
end
