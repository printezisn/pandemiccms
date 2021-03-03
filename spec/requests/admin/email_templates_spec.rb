# frozen_string_literal: true

require 'rails_helper'
require './spec/requests/admin/shared/access_spec'

RSpec.describe '/admin/email_templates', type: :request do
  let(:admin_user) { FactoryBot.create(:admin_user) }
  let!(:supervisor) { FactoryBot.create(:admin_user, :supervisor) }

  let(:signed_in_user) { supervisor }

  let(:model) { FactoryBot.create(:email_template, type: EmailTemplateType::EmailChange.name) }

  before do
    sign_in signed_in_user if signed_in_user
  end

  describe 'GET /index' do
    let(:request) { get admin_email_templates_path }

    it_behaves_like 'supervisor page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    let(:request) { get admin_email_template_path(model) }

    it_behaves_like 'supervisor page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    let(:request) { get edit_admin_email_template_path(model) }

    it_behaves_like 'supervisor page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'PATCH /update' do
    let(:email_template_params) do
      {
        'subject' => 'New subject',
        'body' => 'New body'
      }
    end

    let(:request) do
      patch admin_email_template_path(model), params: { email_template: email_template_params }
    end

    it_behaves_like 'supervisor page'

    context 'with valid parameters' do
      it 'updates the requested email template' do
        request

        expect(model.reload.attributes.slice('subject', 'body')).to eq(email_template_params)
      end

      it 'redirects to the email template' do
        request

        expect(response).to redirect_to(admin_email_template_path(id: model.id, locale: 'en'))
      end
    end

    context 'with invalid parameters' do
      let(:email_template_params) do
        {
          'subject' => '',
          'body' => 'New body'
        }
      end

      it 'returns a successful response' do
        request

        expect(response).to be_successful
      end
    end
  end

  describe 'GET /translate' do
    let(:request) { get translate_admin_email_template_path(model) }

    it_behaves_like 'supervisor page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'POST /translate' do
    let(:translation_params) do
      {
        'subject' => 'Translated Subject',
        'body' => 'Translated body'
      }
    end

    let(:request) do
      post translate_admin_email_template_path(model), params: { translation_locale: 'en', email_template: translation_params }
    end

    it_behaves_like 'supervisor page'

    context 'with valid parameters' do
      it 'translates the requested email template' do
        request

        expect(model.reload.translate(:en).attributes.slice(*translation_params.keys)).to eq(translation_params)
      end

      it 'redirects to the email template translation' do
        request

        expect(response).to redirect_to(translate_admin_email_template_path(id: model.id, locale: 'en', translation_locale: 'en'))
      end
    end

    context 'with invalid parameters' do
      let(:translation_params) do
        {
          'subject' => Array.new(256) { 'a' }.join,
          'body' => 'Translated body'
        }
      end

      it 'returns a successful response' do
        request

        expect(response).to be_successful
      end
    end
  end

  describe 'POST /test' do
    let(:request) { post test_admin_email_template_path(model) }

    it_behaves_like 'supervisor page'

    it 'sends a test email' do
      expect { request }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it 'redirects to the email template' do
      request

      expect(response).to redirect_to(admin_email_template_path(id: model.id, locale: 'en'))
    end
  end
end
