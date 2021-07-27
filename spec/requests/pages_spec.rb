# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Pages', type: :request do
  subject!(:model) do
    FactoryBot.create(
      :page,
      template: template,
      status: status,
      visibility: visibility
    )
  end

  let(:template) { 'default' }
  let(:status) { 'published' }
  let(:visibility) { 'public' }

  describe 'GET /index' do
    let(:request) { get root_path }
    let(:template) { 'index' }

    context 'when there is no index page' do
      let(:template) { 'default' }

      it 'raises an activerecord not found error' do
        expect { request }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the page is private' do
      let(:visibility) { 'private' }

      it 'raises a routing error' do
        expect { request }.to raise_error(ActionController::RoutingError)
      end
    end

    context 'when the page is draft' do
      let(:status) { 'draft' }

      it 'raises a routing error' do
        expect { request }.to raise_error(ActionController::RoutingError)
      end
    end

    context 'when the page is visible' do
      it 'is successful' do
        request

        expect(response).to be_successful
      end
    end
  end

  describe 'GET /show' do
    let(:request) { get page_path(id: model.id, slug: slug) }
    let(:slug) { model.displayed_slug(nil) }

    context 'when the page is private' do
      let(:visibility) { 'private' }

      it 'raises a routing error' do
        expect { request }.to raise_error(ActionController::RoutingError)
      end
    end

    context 'when the page is draft' do
      let(:status) { 'draft' }

      it 'raises a routing error' do
        expect { request }.to raise_error(ActionController::RoutingError)
      end
    end

    context 'when the page is visible' do
      it 'is successful' do
        request

        expect(response).to be_successful
      end
    end

    context 'when the slug is different' do
      let(:request) { get page_path(id: model.id, slug: 'different-slug') }

      it 'has a moved_permanently status' do
        request

        expect(response).to be_moved_permanently
      end

      it 'redirects to the correct slug' do
        request

        expect(response).to redirect_to(page_path(id: model.id, slug: slug))
      end
    end
  end
end
