# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'posts' do
  subject!(:model) do
    create(
      :post,
      template:,
      status:,
      visibility:,
      published_at: Time.now.utc
    )
  end

  let(:template) { 'default' }
  let(:status) { 'published' }
  let(:visibility) { 'public' }

  describe 'GET /show' do
    let(:request) { get post_path(id: model.id, slug:) }
    let(:slug) { model.displayed_slug(nil) }

    context 'when the post is private' do
      let(:visibility) { 'private' }

      it 'raises a routing error' do
        expect { request }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the post is draft' do
      let(:status) { 'draft' }

      it 'raises a routing error' do
        expect { request }.to raise_error(ActiveRecord::RecordNotFound)
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

      it 'has a moved_permanently status' do
        request

        expect(response).to be_moved_permanently
      end

      it 'redirects to the correct slug' do
        request

        expect(response).to redirect_to(post_path(id: model.id, slug:))
      end
    end
  end
end
