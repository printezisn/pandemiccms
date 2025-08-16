# frozen_string_literal: true

RSpec.shared_examples 'Sluggable' do
  describe 'generate_slug' do
    let(:name) { 'Test Name' }
    let(:slug) { 'test-slug' }

    before do
      model.name = name
      model.slug = slug
      model.save!
    end

    context 'when slug is present' do
      it { expect(model.slug).to eq(slug) }
    end

    context 'when slug is not present' do
      let(:slug) { nil }

      it { expect(model.slug).to eq('test-name') }

      context 'when transliteration is greek' do
        let(:name) { 'Μαγειρέματα και Κουρέματα' }
        let(:slug) { nil }

        it { expect(model.slug).to eq('mageiremata-kai-koyremata') }
      end
    end
  end
end
