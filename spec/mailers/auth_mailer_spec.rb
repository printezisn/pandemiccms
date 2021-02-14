# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthMailer, type: :mailer do
  describe 'confirmation_instructions' do
    subject(:mail) { described_class.confirmation_instructions(admin_user, token) }

    let(:admin_user) { FactoryBot.create(:admin_user) }
    let(:token) { 'test_token' }
    let(:email_subject) { 'Hi {user.username}!' }
    let(:email_body) { 'Hi {user.username}! Activate your email <a href="{user.confirmation_link}">here</a>' }

    before do
      FactoryBot.create(
        :email_template,
        type: EmailTemplateType::AccountConfirmation.name,
        subject: email_subject,
        body: email_body
      )
    end

    it 'renders the mail' do
      expect(mail.from).to contain_exactly(admin_user.client.email)
      expect(mail.to).to contain_exactly(admin_user.email)
      expect(mail.subject).to eq("Hi #{admin_user.username}!")
      expect(mail.body.encoded).to eq("Hi #{admin_user.username}! Activate your email <a href=\"" \
                                      "http://example.com/en/admin_users/confirmation?confirmation_token=#{token}\">here</a>")
    end
  end

  describe 'reset_password_instructions' do
    subject(:mail) { described_class.reset_password_instructions(admin_user, token) }

    let(:admin_user) { FactoryBot.create(:admin_user) }
    let(:token) { 'test_token' }
    let(:email_subject) { 'Hi {user.username}!' }
    let(:email_body) { 'Hi {user.username}! Reset your password <a href="{user.reset_password_link}">here</a>' }

    before do
      FactoryBot.create(
        :email_template,
        type: EmailTemplateType::ResetPasswordInstructions.name,
        subject: email_subject,
        body: email_body
      )
    end

    it 'renders the mail' do
      expect(mail.from).to contain_exactly(admin_user.client.email)
      expect(mail.to).to contain_exactly(admin_user.email)
      expect(mail.subject).to eq("Hi #{admin_user.username}!")
      expect(mail.body.encoded).to eq("Hi #{admin_user.username}! Reset your password <a href=\"" \
                                      "http://example.com/en/admin_users/password/edit?reset_password_token=#{token}\">here</a>")
    end
  end

  describe 'email_changed' do
    subject(:mail) { described_class.email_changed(admin_user) }

    let(:admin_user) { FactoryBot.create(:admin_user) }
    let(:email_subject) { 'Hi {user.username}!' }
    let(:email_body) { 'Hi {user.username}! Your email is being changed to {user.unconfirmed_email}' }

    before do
      FactoryBot.create(
        :email_template,
        type: EmailTemplateType::EmailChange.name,
        subject: email_subject,
        body: email_body
      )

      admin_user.update!(email: 'unconfirmed@email.com')
    end

    it 'renders the mail' do
      expect(mail.from).to contain_exactly(admin_user.client.email)
      expect(mail.to).to contain_exactly(admin_user.email)
      expect(mail.subject).to eq("Hi #{admin_user.username}!")
      expect(mail.body.encoded).to eq("Hi #{admin_user.username}! Your email is being changed to #{admin_user.unconfirmed_email}")
    end
  end

  describe 'password_change' do
    subject(:mail) { described_class.password_change(admin_user) }

    let(:admin_user) { FactoryBot.create(:admin_user) }
    let(:email_subject) { 'Hi {user.username}!' }
    let(:email_body) { 'Hi {user.username}! Your password has changed' }

    before do
      FactoryBot.create(
        :email_template,
        type: EmailTemplateType::PasswordChange.name,
        subject: email_subject,
        body: email_body
      )
    end

    it 'renders the mail' do
      expect(mail.from).to contain_exactly(admin_user.client.email)
      expect(mail.to).to contain_exactly(admin_user.email)
      expect(mail.subject).to eq("Hi #{admin_user.username}!")
      expect(mail.body.encoded).to eq("Hi #{admin_user.username}! Your password has changed")
    end
  end
end
