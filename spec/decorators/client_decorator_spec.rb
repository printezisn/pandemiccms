# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ClientDecorator do
  subject(:model) { create(:client).decorate }

  describe '#image_path_with_default' do
    subject { model.image_path_with_default(size) }

    let(:size) { [32, 32] }

    context 'when the client has an image' do
      let(:file) do
        {
          io: Rails.root.join('spec/fixtures/test.png').open,
          filename: 'test.png'
        }
      end
      let(:image_variant) { model.image.variant(resize_to_limit: size) }
      let(:expected_result) do
        Rails.application.routes.url_helpers.rails_representation_url(image_variant, only_path: true, locale: nil)
      end

      before { model.image.attach(file) }

      it { is_expected.to eq(expected_result) }
    end

    context 'when the client does not have an image' do
      it { is_expected.to eq('/logo.png') }
    end
  end
end
