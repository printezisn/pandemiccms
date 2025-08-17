# frozen_string_literal: true

require 'rails_helper'
require './spec/requests/admin/shared/access'

RSpec.describe '/admin/contents' do
  let!(:admin_user) { create(:admin_user) }
  let(:signed_in_user) { admin_user }

  let(:model) { build(:content) }

  before do
    sign_in signed_in_user if signed_in_user
  end

  describe 'GET /index' do
    let(:request) { get admin_contents_path }

    before { model.save! }

    it_behaves_like 'admin user page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    let(:request) { get admin_content_path(model) }

    before { model.save! }

    it_behaves_like 'admin user page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    let(:request) { get new_admin_content_path }

    it_behaves_like 'admin user page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    let(:request) { get edit_admin_content_path(model) }

    before { model.save! }

    it_behaves_like 'admin user page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    let(:content_params) do
      {
        image: Rack::Test::UploadedFile.new(File.open(Rails.root.join('spec/fixtures/test.png'))),
        name: model.name,
        order: 1,
        simple_text: model.simple_text,
        rich_text: model.rich_text
      }
    end

    let(:request) { post admin_contents_path, params: { content: content_params } }

    it_behaves_like 'admin user page'

    context 'with valid parameters' do
      it 'creates a new content' do
        expect { request }.to change(Content, :count).by(1)
      end

      it 'redirects to the created content' do
        request

        expect(response).to redirect_to(admin_content_path(id: Content.last.id))
      end

      it 'bumps cache version' do
        expect { request }.to(change { CacheVersionGetter.call(admin_user.client_id) })
      end
    end

    context 'with invalid parameters' do
      let(:content_params) do
        {
          image: Rack::Test::UploadedFile.new(File.open(Rails.root.join('spec/fixtures/test.png'))),
          name: '',
          order: 1,
          simple_text: model.simple_text,
          rich_text: model.rich_text
        }
      end

      it 'does not create a new content' do
        expect { request }.not_to change(Content, :count)
      end

      it 'returns a successful response' do
        request

        expect(response).to be_successful
      end
    end
  end

  describe 'PATCH /update' do
    let(:content_params) do
      {
        image: Rack::Test::UploadedFile.new(File.open(Rails.root.join('spec/fixtures/test.png'))),
        order: 1,
        simple_text: 'New Simple Text',
        rich_text: model.rich_text
      }
    end

    let(:request) { patch admin_content_path(model), params: { content: content_params } }

    before { model.save! }

    it_behaves_like 'admin user page'

    context 'with valid parameters' do
      it 'updates the requested content' do
        request

        expect(model.reload.simple_text).to eq(content_params[:simple_text])
      end

      it 'redirects to the content' do
        request

        expect(response).to redirect_to(admin_content_path(id: model.id))
      end

      it 'bumps cache version' do
        expect { request }.to(change { CacheVersionGetter.call(admin_user.client_id) })
      end
    end

    context 'with invalid parameters' do
      let(:content_params) do
        {
          name: '',
          order: 1,
          simple_text: model.simple_text,
          rich_text: model.rich_text
        }
      end

      it 'returns a successful response' do
        request

        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE /destroy' do
    let(:request) { delete admin_content_path(model) }

    before { model.save! }

    it_behaves_like 'admin user page'

    it 'destroys the requested content' do
      expect { request }.to change(Content, :count).by(-1)
    end

    it 'redirects to the contents list' do
      request

      expect(response).to redirect_to(admin_contents_path)
    end

    it 'bumps cache version' do
      expect { request }.to(change { CacheVersionGetter.call(admin_user.client_id) })
    end
  end

  describe 'GET /translate' do
    let(:request) { get translate_admin_content_path(model) }

    before { model.save! }

    it_behaves_like 'admin user page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'POST /translate' do
    let(:translation_params) do
      {
        'name' => 'Translated Name',
        'simple_text' => 'Translated Simple Text',
        'rich_text' => 'Translated Rich Text'
      }
    end

    let(:request) do
      post translate_admin_content_path(model), params: { translation_locale: 'en-GB', content: translation_params }
    end

    before { model.save! }

    it_behaves_like 'admin user page'

    context 'with valid parameters' do
      it 'translates the requested content' do
        request

        expect(model.reload.translate('en-GB').attributes.slice(*translation_params.keys)).to eq(translation_params)
      end

      it 'redirects to the content translation' do
        request

        expect(response).to redirect_to(translate_admin_content_path(id: model.id, translation_locale: 'en-GB'))
      end

      it 'bumps cache version' do
        expect { request }.to(change { CacheVersionGetter.call(admin_user.client_id) })
      end
    end

    context 'with invalid parameters' do
      let(:translation_params) do
        {
          'name' => Array.new(256) { 'a' }.join,
          'simple_text' => 'Translated Simple Text',
          'rich_text' => 'Translated Rich Text'
        }
      end

      it 'returns a successful response' do
        request

        expect(response).to be_successful
      end
    end
  end
end
