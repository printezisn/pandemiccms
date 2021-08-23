# frozen_string_literal: true

require 'rails_helper'
require './spec/requests/admin/shared/access'

RSpec.describe '/admin/menus', type: :request do
  let!(:admin_user) { FactoryBot.create(:admin_user) }
  let(:signed_in_user) { admin_user }

  let(:model) { FactoryBot.build(:menu) }

  before do
    sign_in signed_in_user if signed_in_user
  end

  describe 'GET /index' do
    let(:request) { get admin_menus_path }

    before { model.save! }

    it_behaves_like 'admin user page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    let(:request) { get admin_menu_path(model) }

    before { model.save! }

    it_behaves_like 'admin user page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    let(:request) { get new_admin_menu_path }

    it_behaves_like 'admin user page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    let(:request) { get edit_admin_menu_path(model) }

    before { model.save! }

    it_behaves_like 'admin user page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    let(:menu_params) do
      {
        name: model.name,
        description: model.description
      }
    end

    let(:request) { post admin_menus_path, params: { menu: menu_params } }

    it_behaves_like 'admin user page'

    context 'with valid parameters' do
      it 'creates a new menu' do
        expect { request }.to change(Menu, :count).by(1)
      end

      it 'redirects to the created menu' do
        request

        expect(response).to redirect_to(admin_menu_path(id: Menu.last.id))
      end

      it 'bumps cache version' do
        expect { request }.to(change { CacheVersionGetter.call(admin_user.client_id) })
      end
    end

    context 'with invalid parameters' do
      let(:menu_params) do
        {
          name: '',
          description: model.description
        }
      end

      it 'does not create a new menu' do
        expect { request }.not_to change(Menu, :count)
      end

      it 'returns a successful response' do
        request

        expect(response).to be_successful
      end
    end
  end

  describe 'PATCH /update' do
    let(:menu_params) do
      {
        name: model.name,
        description: 'New description'
      }
    end

    let(:request) { patch admin_menu_path(model), params: { menu: menu_params } }

    before { model.save! }

    it_behaves_like 'admin user page'

    context 'with valid parameters' do
      it 'updates the requested menu' do
        request

        expect(model.reload.description).to eq(menu_params[:description])
      end

      it 'redirects to the menu' do
        request

        expect(response).to redirect_to(admin_menu_path(id: model.id))
      end

      it 'bumps cache version' do
        expect { request }.to(change { CacheVersionGetter.call(admin_user.client_id) })
      end
    end

    context 'with invalid parameters' do
      let(:menu_params) do
        {
          name: '',
          description: 'New description'
        }
      end

      it 'returns a successful response' do
        request

        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE /destroy' do
    let(:request) { delete admin_menu_path(model) }

    before { model.save! }

    it_behaves_like 'admin user page'

    it 'destroys the requested menu' do
      expect { request }.to change(Menu, :count).by(-1)
    end

    it 'redirects to the menus list' do
      request

      expect(response).to redirect_to(admin_menus_path)
    end

    it 'bumps cache version' do
      expect { request }.to(change { CacheVersionGetter.call(admin_user.client_id) })
    end
  end

  describe 'GET /translate' do
    let(:request) { get translate_admin_menu_path(model) }

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
        'description' => 'Translated description'
      }
    end

    let(:request) do
      post translate_admin_menu_path(model), params: { translation_locale: 'en', menu: translation_params }
    end

    before { model.save! }

    it_behaves_like 'admin user page'

    context 'with valid parameters' do
      it 'translates the requested menu' do
        request

        expect(model.reload.translate(:en).attributes.slice(*translation_params.keys)).to eq(translation_params)
      end

      it 'redirects to the menu translation' do
        request

        expect(response).to redirect_to(translate_admin_menu_path(id: model.id, translation_locale: 'en'))
      end

      it 'bumps cache version' do
        expect { request }.to(change { CacheVersionGetter.call(admin_user.client_id) })
      end
    end

    context 'with invalid parameters' do
      let(:translation_params) do
        {
          'name' => Array.new(256) { 'a' }.join,
          'description' => 'Translated description'
        }
      end

      it 'returns a successful response' do
        request

        expect(response).to be_successful
      end
    end
  end
end
