# frozen_string_literal: true

RSpec.shared_examples 'EmailTemplate' do
  subject(:model) { FactoryBot.build(:email_template, type: described_class.name).becomes(described_class) }

  it { is_expected.to belong_to(:client) }

  it { is_expected.to validate_presence_of(:subject).with_message('The subject is required.') }
  it { is_expected.to validate_length_of(:subject).is_at_most(255).with_message('The subject may contain up to 255 characters.') }
  it { is_expected.to validate_presence_of(:body).with_message('The body is required.') }

  describe '#to_email' do
    let(:parameter) { model.parameters.keys.first }
    let(:values) { { parameter => 'Test' } }

    before do
      model.subject = "Subject #{parameter}"
      model.body = "Body #{parameter}"
    end

    it 'replaces parameters and returns the email parts' do
      expect(model.to_email(values)).to eq({ subject: 'Subject Test', body: 'Body Test' })
    end
  end

  describe '#send_test_email' do
    let!(:admin_user) { FactoryBot.create(:admin_user) }

    it 'sends test email' do
      expect { model.send_test_email(admin_user) }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end

  describe 'concerns' do
    let(:translation) { FactoryBot.build(:email_template, type: described_class.name) }

    before { model.save! }

    it_behaves_like 'Translatable'
  end
end
