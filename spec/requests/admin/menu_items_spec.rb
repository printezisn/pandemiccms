# frozen_string_literal: true

require 'rails_helper'
require './spec/requests/admin/shared/access'

RSpec.describe '/admin/menu_items', type: :request do
  let!(:admin_user) { FactoryBot.create(:admin_user) }
  let(:signed_in_user) { admin_user }

  let(:menu) { FactoryBot.create(:menu) }
  let(:model) { FactoryBot.build(:menu_item) }

  before do
    sign_in signed_in_user if signed_in_user
  end

  describe 'GET /show' do
    let(:request) { get admin_menu_menu_item_path(menu_id: model.menu_id, id: model.id) }

    before { model.save! }

    it_behaves_like 'admin user page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    let(:request) { get new_admin_menu_menu_item_path(menu_id: menu.id) }

    it_behaves_like 'admin user page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    let(:request) { get edit_admin_menu_menu_item_path(menu_id: model.menu_id, id: model.id) }

    before { model.save! }

    it_behaves_like 'admin user page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    let(:linkable) { FactoryBot.create(:page) }
    let(:menu_item_params) do
      {
        name: model.name,
        sort_order: 1,
        external_url: model.external_url,
        linkable_id: linkable.id,
        linkable_type: linkable.class.name
      }
    end

    let(:request) { post admin_menu_menu_items_path(menu_id: menu.id), params: { menu_item: menu_item_params } }

    it_behaves_like 'admin user page'

    context 'with valid parameters' do
      it 'creates a new menu item' do
        expect { request }.to change(MenuItem, :count).by(1)
      end

      it 'redirects to the created menu item' do
        request

        expect(response).to redirect_to(admin_menu_menu_item_path(id: MenuItem.last.id, menu_id: menu.id, locale: 'en'))
      end
    end

    context 'with invalid parameters' do
      let(:menu_item_params) do
        {
          name: '',
          sort_order: 1,
          external_url: model.external_url,
          linkable_id: linkable.id,
          linkable_type: linkable.class.name
        }
      end

      it 'does not create a new menu item' do
        expect { request }.not_to change(MenuItem, :count)
      end

      it 'returns a successful response' do
        request

        expect(response).to be_successful
      end
    end
  end

  describe 'PATCH /update' do
    let(:linkable) { FactoryBot.create(:page) }
    let(:menu_item_params) do
      {
        name: 'New name',
        sort_order: 1,
        external_url: model.external_url,
        linkable_id: linkable.id,
        linkable_type: linkable.class.name
      }
    end

    let(:request) { patch admin_menu_menu_item_path(id: model.id, menu_id: model.menu_id), params: { menu_item: menu_item_params } }

    before { model.save! }

    it_behaves_like 'admin user page'

    context 'with valid parameters' do
      it 'updates the requested menu item' do
        request

        expect(model.reload.name).to eq(menu_item_params[:name])
      end

      it 'redirects to the menu item' do
        request

        expect(response).to redirect_to(admin_menu_menu_item_path(id: model.id, menu_id: model.menu_id, locale: 'en'))
      end
    end

    context 'with invalid parameters' do
      let(:menu_item_params) do
        {
          name: '',
          sort_order: 1,
          external_url: model.external_url,
          linkable_id: linkable.id,
          linkable_type: linkable.class.name
        }
      end

      it 'returns a successful response' do
        request

        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE /destroy' do
    let(:request) { delete admin_menu_menu_item_path(id: model.id, menu_id: model.menu_id) }

    before { model.save! }

    it_behaves_like 'admin user page'

    it 'destroys the requested menu item' do
      expect { request }.to change(MenuItem, :count).by(-1)
    end

    it 'redirects to the menu items list' do
      request

      expect(response).to redirect_to(admin_menu_path(id: model.menu_id, locale: 'en'))
    end
  end

  describe 'GET /translate' do
    let(:request) { get translate_admin_menu_menu_item_path(id: model.id, menu_id: model.menu_id) }

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
        'name' => 'Translated Name'
      }
    end

    let(:request) do
      post translate_admin_menu_menu_item_path(id: model.id, menu_id: model.menu_id),
           params: { translation_locale: 'en', menu_item: translation_params }
    end

    before { model.save! }

    it_behaves_like 'admin user page'

    context 'with valid parameters' do
      it 'translates the requested menu item' do
        request

        expect(model.reload.translate(:en).attributes.slice(*translation_params.keys)).to eq(translation_params)
      end

      it 'redirects to the menu item translation' do
        request

        expect(response).to redirect_to(
          translate_admin_menu_menu_item_path(
            id: model.id, menu_id: model.menu_id, locale: 'en', translation_locale: 'en'
          )
        )
      end
    end

    context 'with invalid parameters' do
      let(:translation_params) do
        {
          'name' => Array.new(256) { 'a' }.join
        }
      end

      it 'returns a successful response' do
        request

        expect(response).to be_successful
      end
    end
  end
end
