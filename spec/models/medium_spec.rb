# frozen_string_literal: true

require 'rails_helper'
require './spec/models/concerns/simple_text_searchable'
require './spec/models/concerns/bound_sortable'

RSpec.describe Medium, type: :model do
  subject(:model) { FactoryBot.build(:medium) }

  let(:file) do
    {
      io: File.open(Rails.root.join('spec/fixtures/test.png')),
      filename: 'test.png'
    }
  end

  it { is_expected.to belong_to(:client) }

  describe 'file' do
    context 'when no file is attached' do
      it { is_expected.to be_invalid }
    end

    context 'when a file is attached' do
      before do
        model.file.attach(file)
      end

      it { is_expected.to be_valid }

      it 'updates the name' do
        expect { model.save! }.to change(model, :name).from(nil).to('test.png')
      end
    end
  end

  describe 'concerns' do
    before do
      model.file.attach(file)
      model.save!
    end

    it_behaves_like 'SimpleTextSearchable'
    it_behaves_like 'BoundSortable'
  end
end
