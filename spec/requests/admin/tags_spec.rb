# frozen_string_literal: true

require 'rails_helper'
require './spec/requests/admin/shared/access'

RSpec.describe '/admin/tags', type: :request do
  let!(:admin_user) { FactoryBot.create(:admin_user) }
  let(:signed_in_user) { admin_user }

  let(:model) { FactoryBot.build(:tag) }

  before do
    sign_in signed_in_user if signed_in_user
  end

  describe 'GET /index' do
    let(:request) { get admin_tags_path }

    before { model.save! }

    it_behaves_like 'admin user page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    let(:request) { get admin_tag_path(model) }

    before { model.save! }

    it_behaves_like 'admin user page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    let(:request) { get new_admin_tag_path }

    it_behaves_like 'admin user page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    let(:request) { get edit_admin_tag_path(model) }

    before { model.save! }

    it_behaves_like 'admin user page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    let(:tag_params) do
      {
        name: model.name,
        slug: model.slug,
        description: model.description,
        template: model.template
      }
    end

    let(:request) { post admin_tags_path, params: { tag: tag_params } }

    it_behaves_like 'admin user page'

    context 'with valid parameters' do
      it 'creates a new tag' do
        expect { request }.to change(Tag, :count).by(1)
      end

      it 'redirects to the created tag' do
        request

        expect(response).to redirect_to(admin_tag_path(id: Tag.last.id, locale: 'en'))
      end

      it 'bumps cache version' do
        expect { request }.to(change { CacheVersionGetter.call(admin_user.client_id) })
      end
    end

    context 'with invalid parameters' do
      let(:tag_params) do
        {
          name: '',
          slug: model.slug,
          description: model.description,
          template: model.template
        }
      end

      it 'does not create a new tag' do
        expect { request }.not_to change(Tag, :count)
      end

      it 'returns a successful response' do
        request

        expect(response).to be_successful
      end
    end
  end

  describe 'PATCH /update' do
    let(:tag_params) do
      {
        name: model.name,
        slug: model.slug,
        description: 'New description',
        template: model.template
      }
    end

    let(:request) { patch admin_tag_path(model), params: { tag: tag_params } }

    before { model.save! }

    it_behaves_like 'admin user page'

    context 'with valid parameters' do
      it 'updates the requested tag' do
        request

        expect(model.reload.description).to eq(tag_params[:description])
      end

      it 'redirects to the tag' do
        request

        expect(response).to redirect_to(admin_tag_path(id: model.id, locale: 'en'))
      end

      it 'bumps cache version' do
        expect { request }.to(change { CacheVersionGetter.call(admin_user.client_id) })
      end
    end

    context 'with invalid parameters' do
      let(:tag_params) do
        {
          name: '',
          slug: model.slug,
          description: 'New description',
          template: model.template
        }
      end

      it 'returns a successful response' do
        request

        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE /destroy' do
    let(:request) { delete admin_tag_path(model) }

    before { model.save! }

    it_behaves_like 'admin user page'

    it 'destroys the requested tag' do
      expect { request }.to change(Tag, :count).by(-1)
    end

    it 'redirects to the tags list' do
      request

      expect(response).to redirect_to(admin_tags_path(locale: 'en'))
    end

    it 'bumps cache version' do
      expect { request }.to(change { CacheVersionGetter.call(admin_user.client_id) })
    end
  end

  describe 'GET /posts' do
    let(:request) { get admin_tag_posts_path(model) }

    before do
      model.save!
      FactoryBot.create(:post, tags: [model])
    end

    it_behaves_like 'admin user page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'GET /pages' do
    let(:request) { get admin_tag_pages_path(model) }

    before do
      model.save!
      FactoryBot.create(:page, tags: [model])
    end

    it_behaves_like 'admin user page'

    it 'returns a successful response' do
      get admin_tag_pages_path(model)

      expect(response).to be_successful
    end
  end

  describe 'GET /translate' do
    let(:request) { get translate_admin_tag_path(model) }

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
        'slug' => 'translated-slug',
        'description' => 'Translated description'
      }
    end

    let(:request) do
      post translate_admin_tag_path(model), params: { translation_locale: 'en', tag: translation_params }
    end

    before { model.save! }

    it_behaves_like 'admin user page'

    context 'with valid parameters' do
      it 'translates the requested tag' do
        request

        expect(model.reload.translate(:en).attributes.slice(*translation_params.keys)).to eq(translation_params)
      end

      it 'redirects to the tag translation' do
        request

        expect(response).to redirect_to(translate_admin_tag_path(id: model.id, locale: 'en', translation_locale: 'en'))
      end

      it 'bumps cache version' do
        expect { request }.to(change { CacheVersionGetter.call(admin_user.client_id) })
      end
    end

    context 'with invalid parameters' do
      let(:translation_params) do
        {
          'name' => Array.new(256) { 'a' }.join,
          'slug' => 'translated-slug',
          'description' => 'Translated description'
        }
      end

      it 'returns a successful response' do
        request

        expect(response).to be_successful
      end
    end
  end

  describe 'GET /search' do
    let(:request) { get search_admin_tags_path(term: model.name) }
    let(:expected_results) do
      {
        'results' => [{ 'id' => model.id, 'text' => model.name }],
        'pagination' => { 'more' => false }
      }
    end
    let(:model) { FactoryBot.create(:tag) }

    it_behaves_like 'admin user page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end

    it 'returns the correct tags' do
      request

      expect(JSON.parse(response.body)).to eq(expected_results)
    end
  end
end
