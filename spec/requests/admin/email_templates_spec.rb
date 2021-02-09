# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/admin/email_templates', type: :request do
  let(:admin_user) { FactoryBot.create(:admin_user) }
  let!(:supervisor) { FactoryBot.create(:admin_user, :supervisor) }

  let(:model) { FactoryBot.build(:email_template, type: EmailTemplateType::EmailChange.name) }

  describe 'GET /index' do
    before { model.save! }

    context 'when the admin user is not signed in' do
      it 'redirects to the sign in page' do
        get admin_email_templates_path

        expect(response).to redirect_to(new_admin_user_session_path)
      end
    end

    context 'when the admin user is not a supervisor' do
      before { sign_in admin_user }

      it 'redirects to the admin dashboard page' do
        get admin_email_templates_path

        expect(response).to redirect_to(admin_root_path(locale: 'en'))
      end
    end

    context 'when the admin user is a supervisor' do
      before { sign_in supervisor }

      it 'returns a successful response' do
        get admin_email_templates_path

        expect(response).to be_successful
      end
    end
  end

  describe 'GET /show' do
    before { model.save! }

    context 'when the admin user is not signed in' do
      it 'redirects to the sign in page' do
        get admin_email_template_path(model)

        expect(response).to redirect_to(new_admin_user_session_path)
      end
    end

    context 'when the admin user is not a supervisor' do
      before { sign_in admin_user }

      it 'redirects to the admin dashboard page' do
        get admin_email_template_path(model)

        expect(response).to redirect_to(admin_root_path(locale: 'en'))
      end
    end

    context 'when the admin user is a supervisor' do
      before { sign_in supervisor }

      it 'returns a successful response' do
        get admin_email_template_path(model)

        expect(response).to be_successful
      end
    end
  end

  describe 'GET /edit' do
    before { model.save! }

    context 'when the admin user is not signed in' do
      it 'redirects to the sign in page' do
        get edit_admin_email_template_path(model)

        expect(response).to redirect_to(new_admin_user_session_path)
      end
    end

    context 'when the admin user is not a supervisor' do
      before { sign_in admin_user }

      it 'redirects to the admin dashboard page' do
        get edit_admin_email_template_path(model)

        expect(response).to redirect_to(admin_root_path(locale: 'en'))
      end
    end

    context 'when the admin user is signed in' do
      before { sign_in supervisor }

      it 'returns a successful response' do
        get edit_admin_email_template_path(model)

        expect(response).to be_successful
      end
    end
  end

  describe 'PATCH /update' do
    let(:email_template_params) do
      {
        'subject' => 'New subject',
        'body' => 'New body'
      }
    end

    before { model.save! }

    context 'when the admin user is not signed in' do
      it 'redirects to the sign in page' do
        patch admin_email_template_path(model)

        expect(response).to redirect_to(new_admin_user_session_path)
      end
    end

    context 'when the admin user is not a supervisor' do
      before { sign_in admin_user }

      it 'redirects to the admin dashboard page' do
        patch admin_email_template_path(model)

        expect(response).to redirect_to(admin_root_path(locale: 'en'))
      end
    end

    context 'with valid parameters' do
      before { sign_in supervisor }

      it 'updates the requested email template' do
        patch admin_email_template_path(model), params: { email_template: email_template_params }

        expect(model.reload.attributes.slice('subject', 'body')).to eq(email_template_params)
      end

      it 'redirects to the email template' do
        patch admin_email_template_path(model), params: { email_template: email_template_params }

        expect(response).to redirect_to(admin_email_template_path(id: model.id, locale: 'en'))
      end
    end

    context 'with invalid parameters' do
      before { sign_in supervisor }

      it 'returns a successful response' do
        patch admin_email_template_path(model), params: { email_template: { subject: '' } }

        expect(response).to be_successful
      end
    end
  end

  describe 'GET /translate' do
    before { model.save! }

    context 'when the admin user is not signed in' do
      it 'redirects to the sign in page' do
        get translate_admin_email_template_path(model)

        expect(response).to redirect_to(new_admin_user_session_path)
      end
    end

    context 'when the admin user is not a supervisor' do
      before { sign_in admin_user }

      it 'redirects to the admin dashboard page' do
        get translate_admin_email_template_path(model)

        expect(response).to redirect_to(admin_root_path(locale: 'en'))
      end
    end

    context 'when the admin user is a supervisor' do
      before { sign_in supervisor }

      it 'returns a successful response' do
        get translate_admin_email_template_path(model)

        expect(response).to be_successful
      end
    end
  end

  describe 'POST /translate' do
    let(:translation_params) do
      {
        'subject' => 'Translated Subject',
        'body' => 'Translated body'
      }
    end

    before { model.save! }

    context 'when the admin user is not signed in' do
      it 'redirects to the sign in page' do
        post translate_admin_email_template_path(model)

        expect(response).to redirect_to(new_admin_user_session_path)
      end
    end

    context 'when the admin user is not a supervisor' do
      before { sign_in admin_user }

      it 'redirects to the admin dashboard page' do
        post translate_admin_email_template_path(model)

        expect(response).to redirect_to(admin_root_path(locale: 'en'))
      end
    end

    context 'with valid parameters' do
      before { sign_in supervisor }

      it 'translates the requested email template' do
        post translate_admin_email_template_path(model), params: { translation_locale: 'en', email_template: translation_params }

        expect(model.reload.translate(:en).attributes.slice(*translation_params.keys)).to eq(translation_params)
      end

      it 'redirects to the email template' do
        post translate_admin_email_template_path(model), params: { translation_locale: 'en', email_template: translation_params }

        expect(response).to redirect_to(translate_admin_email_template_path(id: model.id, locale: 'en', translation_locale: 'en'))
      end
    end

    context 'with invalid parameters' do
      before { sign_in supervisor }

      it 'returns a successful response' do
        post translate_admin_email_template_path(model), params: { email_template: { subject: '' } }

        expect(response).to be_successful
      end
    end
  end
end
