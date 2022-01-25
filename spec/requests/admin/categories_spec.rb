# frozen_string_literal: true

require 'rails_helper'
require './spec/requests/admin/shared/access'

RSpec.describe '/admin/categories', type: :request do
  let!(:admin_user) { create(:admin_user) }
  let(:signed_in_user) { admin_user }

  let(:model) { build(:category) }

  before do
    sign_in signed_in_user if signed_in_user
  end

  describe 'GET /index' do
    let(:request) { get admin_categories_path }

    before { model.save! }

    it_behaves_like 'admin user page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'GET /tree' do
    let(:request) { get tree_admin_categories_path }

    before { model.save! }

    it_behaves_like 'admin user page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    let(:request) { get admin_category_path(model) }

    before { model.save! }

    it_behaves_like 'admin user page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    let(:request) { get new_admin_category_path }

    it_behaves_like 'admin user page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    let(:request) { get edit_admin_category_path(model) }

    before { model.save! }

    it_behaves_like 'admin user page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    let!(:parent) { create(:category) }
    let(:category_params) do
      {
        image: Rack::Test::UploadedFile.new(File.open(Rails.root.join('spec/fixtures/test.png'))),
        name: model.name,
        slug: model.slug,
        description: model.description,
        body: model.body,
        template: model.template,
        visibility: model.visibility,
        parent_id: parent.id
      }
    end

    let(:request) { post admin_categories_path, params: { category: category_params } }

    it_behaves_like 'admin user page'

    context 'with valid parameters' do
      it 'creates a new category' do
        expect { request }.to change(Category, :count).by(1)
      end

      it 'redirects to the created category' do
        request

        expect(response).to redirect_to(admin_category_path(id: Category.last.id))
      end

      it 'bumps cache version' do
        expect { request }.to(change { CacheVersionGetter.call(admin_user.client_id) })
      end
    end

    context 'with invalid parameters' do
      let(:category_params) do
        {
          image: Rack::Test::UploadedFile.new(File.open(Rails.root.join('spec/fixtures/test.png'))),
          name: '',
          slug: model.slug,
          description: model.description,
          body: model.body,
          template: model.template,
          visibility: model.visibility,
          parent_id: parent.id
        }
      end

      it 'does not create a new category' do
        expect { request }.not_to change(Category, :count)
      end

      it 'returns a successful response' do
        request

        expect(response).to be_successful
      end
    end
  end

  describe 'PATCH /update' do
    let!(:parent) { create(:category) }
    let(:category_params) do
      {
        image: Rack::Test::UploadedFile.new(File.open(Rails.root.join('spec/fixtures/test.png'))),
        name: model.name,
        slug: model.slug,
        description: 'New description',
        body: model.body,
        template: model.template,
        visibility: model.visibility,
        parent_id: parent.id
      }
    end

    let(:request) { patch admin_category_path(model), params: { category: category_params } }

    before { model.save! }

    it_behaves_like 'admin user page'

    context 'with valid parameters' do
      it 'updates the requested category' do
        request

        expect(model.reload.description).to eq(category_params[:description])
      end

      it 'redirects to the category' do
        request

        expect(response).to redirect_to(admin_category_path(id: model.id))
      end

      it 'bumps cache version' do
        expect { request }.to(change { CacheVersionGetter.call(admin_user.client_id) })
      end
    end

    context 'with invalid parameters' do
      let(:category_params) do
        {
          name: '',
          slug: model.slug,
          description: 'New description',
          body: model.body,
          template: model.template,
          visibility: model.visibility
        }
      end

      it 'returns a successful response' do
        request

        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE /destroy' do
    let(:request) { delete admin_category_path(model) }

    before { model.save! }

    it_behaves_like 'admin user page'

    it 'destroys the requested category' do
      expect { request }.to change(Category, :count).by(-1)
    end

    it 'redirects to the categories list' do
      request

      expect(response).to redirect_to(admin_categories_path)
    end

    it 'bumps cache version' do
      expect { request }.to(change { CacheVersionGetter.call(admin_user.client_id) })
    end
  end

  describe 'GET /posts' do
    let(:request) { get admin_category_posts_path(model) }

    before do
      model.save!
      create(:post, categories: [model])
    end

    it_behaves_like 'admin user page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'GET /translate' do
    let(:request) { get translate_admin_category_path(model) }

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
        'description' => 'Translated description',
        'body' => 'Translated body'
      }
    end

    let(:request) do
      post translate_admin_category_path(model), params: { translation_locale: 'en-GB', category: translation_params }
    end

    before { model.save! }

    it_behaves_like 'admin user page'

    context 'with valid parameters' do
      it 'translates the requested category' do
        request

        expect(model.reload.translate('en-GB').attributes.slice(*translation_params.keys)).to eq(translation_params)
      end

      it 'redirects to the category translation' do
        request

        expect(response).to redirect_to(translate_admin_category_path(id: model.id, translation_locale: 'en-GB'))
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
          'description' => 'Translated description',
          'body' => 'Translated body'
        }
      end

      it 'returns a successful response' do
        request

        expect(response).to be_successful
      end
    end
  end

  describe 'GET /search' do
    let(:request) { get search_admin_categories_path(excluded_id: model.id, term: model.parent.name) }
    let(:expected_results) do
      {
        'results' => [{ 'id' => model.parent.id, 'text' => model.parent.name }],
        'pagination' => { 'more' => false }
      }
    end
    let(:model) { create(:category, :with_parent) }

    it_behaves_like 'admin user page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end

    it 'returns the correct categories' do
      request

      expect(JSON.parse(response.body)).to eq(expected_results)
    end
  end
end
