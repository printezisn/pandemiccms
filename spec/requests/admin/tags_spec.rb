# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/admin/tags', type: :request do
  let!(:admin_user) { FactoryBot.create(:admin_user) }

  let(:model) { FactoryBot.build(:tag) }

  describe 'GET /index' do
    before { model.save! }

    context 'when the admin user is not signed in' do
      it 'redirects to the sign in page' do
        get admin_tags_path

        expect(response).to redirect_to(new_admin_user_session_path)
      end
    end

    context 'when the admin user is signed in' do
      before { sign_in admin_user }

      it 'returns a successful response' do
        get admin_tags_path

        expect(response).to be_successful
      end
    end
  end

  describe 'GET /show' do
    before { model.save! }

    context 'when the admin user is not signed in' do
      it 'redirects to the sign in page' do
        get admin_tag_path(model)

        expect(response).to redirect_to(new_admin_user_session_path)
      end
    end

    context 'when the admin user is signed in' do
      before { sign_in admin_user }

      it 'returns a successful response' do
        get admin_tag_path(model)

        expect(response).to be_successful
      end
    end
  end

  describe 'GET /new' do
    context 'when the admin user is not signed in' do
      it 'redirects to the sign in page' do
        get new_admin_tag_path

        expect(response).to redirect_to(new_admin_user_session_path)
      end
    end

    context 'when the admin user is signed in' do
      before { sign_in admin_user }

      it 'returns a successful response' do
        get new_admin_tag_path

        expect(response).to be_successful
      end
    end
  end

  describe 'GET /edit' do
    before { model.save! }

    context 'when the admin user is not signed in' do
      it 'redirects to the sign in page' do
        get edit_admin_tag_path(model)

        expect(response).to redirect_to(new_admin_user_session_path)
      end
    end

    context 'when the admin user is signed in' do
      before { sign_in admin_user }

      it 'returns a successful response' do
        get edit_admin_tag_path(model)

        expect(response).to be_successful
      end
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

    context 'when the admin user is not signed in' do
      it 'redirects to the sign in page' do
        get new_admin_tag_path

        expect(response).to redirect_to(new_admin_user_session_path)
      end
    end

    context 'with valid parameters' do
      before { sign_in admin_user }

      it 'creates a new tag' do
        expect do
          post admin_tags_path, params: { tag: tag_params }
        end.to change(Tag, :count).by(1)
      end

      it 'redirects to the created tag' do
        post admin_tags_path, params: { tag: tag_params }

        expect(response).to redirect_to(admin_tag_path(id: Tag.last.id, locale: 'en'))
      end
    end

    context 'with invalid parameters' do
      before { sign_in admin_user }

      it 'does not create a new tag' do
        expect do
          post admin_tags_path, params: { tag: { name: '' } }
        end.not_to change(Tag, :count)
      end

      it 'returns a successful response' do
        post admin_tags_path, params: { tag: { name: '' } }

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

    before { model.save! }

    context 'when the admin user is not signed in' do
      it 'redirects to the sign in page' do
        patch admin_tag_path(model)

        expect(response).to redirect_to(new_admin_user_session_path)
      end
    end

    context 'with valid parameters' do
      before { sign_in admin_user }

      it 'updates the requested tag' do
        patch admin_tag_path(model), params: { tag: tag_params }

        expect(model.reload.description).to eq(tag_params[:description])
      end

      it 'redirects to the tag' do
        patch admin_tag_path(model), params: { tag: tag_params }

        expect(response).to redirect_to(admin_tag_path(id: model.id, locale: 'en'))
      end
    end

    context 'with invalid parameters' do
      before { sign_in admin_user }

      it 'returns a successful response' do
        patch admin_tag_path(model), params: { tag: { name: '' } }

        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE /destroy' do
    before { model.save! }

    context 'when the admin user is not signed in' do
      it 'redirects to the sign in page' do
        delete admin_tag_path(model)

        expect(response).to redirect_to(new_admin_user_session_path)
      end
    end

    context 'when the admin user is signed in' do
      before { sign_in admin_user }

      it 'destroys the requested tag' do
        expect { delete admin_tag_path(model) }.to change(Tag, :count).by(-1)
      end

      it 'redirects to the tags list' do
        delete admin_tag_path(model)

        expect(response).to redirect_to(admin_tags_path(locale: 'en'))
      end
    end
  end

  describe 'GET /posts' do
    before do
      model.save!
      FactoryBot.create(:post, tags: [model])
    end

    context 'when the admin user is not signed in' do
      it 'redirects to the sign in page' do
        get admin_tag_posts_path(model)

        expect(response).to redirect_to(new_admin_user_session_path)
      end
    end

    context 'when the admin user is signed in' do
      before { sign_in admin_user }

      it 'returns a successful response' do
        get admin_tag_posts_path(model)

        expect(response).to be_successful
      end
    end
  end

  describe 'GET /pages' do
    before do
      model.save!
      FactoryBot.create(:page, tags: [model])
    end

    context 'when the admin user is not signed in' do
      it 'redirects to the sign in page' do
        get admin_tag_pages_path(model)

        expect(response).to redirect_to(new_admin_user_session_path)
      end
    end

    context 'when the admin user is signed in' do
      before { sign_in admin_user }

      it 'returns a successful response' do
        get admin_tag_pages_path(model)

        expect(response).to be_successful
      end
    end
  end
end
