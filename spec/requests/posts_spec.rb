# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'posts', type: :request do
  subject!(:model) do
    FactoryBot.create(
      :post,
      template: template,
      status: status,
      visibility: visibility
    )
  end

  let(:template) { 'default' }
  let(:status) { 'published' }
  let(:visibility) { 'public' }

  describe 'GET /show' do
    let(:request) { get post_path(id: model.id, slug: slug) }
    let(:slug) { model.displayed_slug(nil) }

    context 'when the post is private' do
      let(:visibility) { 'private' }

      it 'raises a routing error' do
        expect { request }.to raise_error(ActionController::RoutingError)
      end
    end

    context 'when the post is draft' do
      let(:status) { 'draft' }

      it 'raises a routing error' do
        expect { request }.to raise_error(ActionController::RoutingError)
      end
    end

    context 'when the post is visible' do
      it 'is successful' do
        request

        expect(response).to be_successful
      end
    end

    context 'when the slug is different' do
      let(:request) { get post_path(id: model.id, slug: 'different-slug') }

      it 'redirects to the correct slug' do
        request

        expect(response).to redirect_to(post_path(id: model.id, slug: slug))
      end
    end
  end
end
