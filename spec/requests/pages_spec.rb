# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Pages' do
  subject!(:model) do
    create(
      :page,
      template:,
      status:,
      visibility:
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

      it 'redirects to 404' do
        request

        expect(response).to be_not_found
      end
    end

    context 'when the page is private' do
      let(:visibility) { 'private' }

      it 'redirects to 404' do
        request

        expect(response).to be_not_found
      end
    end

    context 'when the page is draft' do
      let(:status) { 'draft' }

      it 'redirects to 404' do
        request

        expect(response).to be_not_found
      end
    end

    context 'when the page is visible' do
      it 'is successful' do
        request

        expect(response).to be_successful
      end

      it 'tracks a new page visit' do
        expect { request }.to change { Ahoy::Event.where(name: 'Page Visit').count }.by(1)
      end
    end
  end

  describe 'GET /show' do
    let(:request) { get sample_page_path(id: model.id, slug:) }
    let(:slug) { model.slug }

    context 'when the page is private' do
      let(:visibility) { 'private' }

      it 'redirects to 404' do
        request

        expect(response).to be_not_found
      end
    end

    context 'when the page is draft' do
      let(:status) { 'draft' }

      it 'redirects to 404' do
        request

        expect(response).to be_not_found
      end
    end

    context 'when the page is visible' do
      it 'is successful' do
        request

        expect(response).to be_successful
      end

      it 'tracks a new page visit' do
        expect { request }.to change { Ahoy::Event.where(name: 'Page Visit').count }.by(1)
      end
    end

    context 'when the slug is different' do
      let(:request) { get sample_page_path(id: model.id, slug: 'different-slug') }

      it 'has a moved_permanently status' do
        request

        expect(response).to be_moved_permanently
      end

      it 'redirects to the correct slug' do
        request

        expect(response).to redirect_to sample_page_path(id: model.id, slug:, locale: nil)
      end
    end
  end
end
