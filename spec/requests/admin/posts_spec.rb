# frozen_string_literal: true

require 'rails_helper'
require './spec/requests/admin/shared/access'

RSpec.describe '/admin/posts', type: :request do
  let!(:admin_user) { create(:admin_user) }
  let(:signed_in_user) { admin_user }

  let(:model) { build(:post, author_id: admin_user.id) }

  before do
    sign_in signed_in_user if signed_in_user
  end

  describe 'GET /index' do
    let(:request) { get admin_posts_path }

    before { model.save! }

    it_behaves_like 'admin user page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    let(:request) { get admin_post_path(model) }

    before { model.save! }

    it_behaves_like 'admin user page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    let(:request) { get new_admin_post_path }

    it_behaves_like 'admin user page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    let(:request) { get edit_admin_post_path(model) }

    before { model.save! }

    it_behaves_like 'admin user page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    let(:post_params) do
      {
        image: Rack::Test::UploadedFile.new(File.open(Rails.root.join('spec/fixtures/test.png'))),
        name: model.name,
        slug: model.slug,
        description: model.description,
        body: model.body,
        template: model.template,
        visibility: :private
      }
    end

    let(:request) { post admin_posts_path, params: { post: post_params } }

    it_behaves_like 'admin user page'

    context 'with valid parameters' do
      it 'creates a new post' do
        expect { request }.to change(Post, :count).by(1)
      end

      it 'redirects to the created post' do
        request

        expect(response).to redirect_to(admin_post_path(id: Post.last.id))
      end

      it 'bumps cache version' do
        expect { request }.to(change { CacheVersionGetter.call(admin_user.client_id) })
      end
    end

    context 'with invalid parameters' do
      let(:post_params) do
        {
          image: Rack::Test::UploadedFile.new(File.open(Rails.root.join('spec/fixtures/test.png'))),
          name: '',
          slug: model.slug,
          description: model.description,
          body: model.body,
          template: model.template,
          visibility: :private
        }
      end

      it 'does not create a new post' do
        expect { request }.not_to change(Post, :count)
      end

      it 'returns a successful response' do
        request

        expect(response).to be_successful
      end
    end
  end

  describe 'PATCH /update' do
    let(:post_params) do
      {
        image: Rack::Test::UploadedFile.new(File.open(Rails.root.join('spec/fixtures/test.png'))),
        name: model.name,
        slug: model.slug,
        description: 'New description',
        body: model.body,
        template: model.template,
        visibility: :private
      }
    end

    let(:request) { patch admin_post_path(model), params: { post: post_params } }

    before { model.save! }

    it_behaves_like 'admin user page'

    context 'with valid parameters' do
      it 'updates the requested post' do
        request

        expect(model.reload.description).to eq(post_params[:description])
      end

      it 'redirects to the post' do
        request

        expect(response).to redirect_to(admin_post_path(id: model.id))
      end

      it 'bumps cache version' do
        expect { request }.to(change { CacheVersionGetter.call(admin_user.client_id) })
      end
    end

    context 'with invalid parameters' do
      let(:post_params) do
        {
          name: '',
          slug: model.slug,
          description: 'New description',
          body: model.body,
          template: model.template,
          visibility: :private
        }
      end

      it 'returns a successful response' do
        request

        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE /destroy' do
    let(:request) { delete admin_post_path(model) }

    before { model.save! }

    it_behaves_like 'admin user page'

    it 'destroys the requested post' do
      expect { request }.to change(Post, :count).by(-1)
    end

    it 'redirects to the posts list' do
      request

      expect(response).to redirect_to(admin_posts_path)
    end

    it 'bumps cache version' do
      expect { request }.to(change { CacheVersionGetter.call(admin_user.client_id) })
    end
  end

  describe 'GET /translate' do
    let(:request) { get translate_admin_post_path(model) }

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
        'body' => 'Translated Body'
      }
    end

    let(:request) do
      post translate_admin_post_path(model), params: { translation_locale: 'en-GB', post: translation_params }
    end

    before { model.save! }

    it_behaves_like 'admin user page'

    context 'with valid parameters' do
      it 'translates the requested post' do
        request

        expect(model.reload.translate('en-GB').attributes.slice(*translation_params.keys)).to eq(translation_params)
      end

      it 'redirects to the post translation' do
        request

        expect(response).to redirect_to(translate_admin_post_path(id: model.id, translation_locale: 'en-GB'))
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
    let(:request) { get search_admin_posts_path(term: model.name) }
    let(:expected_results) do
      {
        'results' => [{ 'id' => model.id, 'text' => model.name }],
        'pagination' => { 'more' => false }
      }
    end
    let(:model) { create(:post) }

    it_behaves_like 'admin user page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end

    it 'returns the correct posts' do
      request

      expect(JSON.parse(response.body)).to eq(expected_results)
    end
  end

  describe 'POST /publish' do
    let(:request) { post publish_admin_post_path(model) }

    let(:model) { create(:post) }

    it_behaves_like 'admin user page'

    it 'redirects to the post' do
      request

      expect(response).to redirect_to(admin_post_path(id: model.id))
    end

    it 'changes the post status' do
      expect { request }.to change { model.reload.status }.from('draft').to('published')
    end

    it 'bumps cache version' do
      expect { request }.to(change { CacheVersionGetter.call(admin_user.client_id) })
    end
  end
end
