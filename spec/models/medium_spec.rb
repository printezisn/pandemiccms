# frozen_string_literal: true

require 'rails_helper'
require_relative 'concerns/simple_text_searchable_spec'

RSpec.describe Medium, type: :model do
  subject(:model) { FactoryBot.build(:medium) }

  it { is_expected.to validate_presence_of(:client_id) }

  describe 'file' do
    context 'when no file is attached' do
      it { is_expected.to be_invalid }
    end

    context 'when a file is attached' do
      before do
        model.file.attach(io: File.open(Rails.root.join('spec/fixtures/test.png')), filename: 'test.png')
      end

      it { is_expected.to be_valid }

      it 'updates the name' do
        expect { model.save! }.to change(model, :name).from(nil).to('test.png')
      end
    end
  end

  describe 'SimpleTextSearchable' do
    subject(:model) do
      model = FactoryBot.build(:medium)
      model.file.attach(io: File.open(Rails.root.join('spec/fixtures/test.png')), filename: 'test.png')
      model.save!

      model
    end

    it_behaves_like 'SimpleTextSearchable'
  end
end
