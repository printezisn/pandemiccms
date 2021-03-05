# frozen_string_literal: true

RSpec.shared_examples 'Sluggable' do
  describe '#displayed_slug' do
    let(:name) { 'Test Name' }
    let(:slug) { 'test-slug' }
    let(:transliterations) { nil }

    before do
      model.name = name
      model.slug = slug
    end

    context 'when slug is present' do
      it { expect(model.displayed_slug(transliterations)).to eq(slug) }
    end

    context 'when slug is not present' do
      let(:slug) { nil }

      it { expect(model.displayed_slug(transliterations)).to eq('test-name') }

      context 'when transliteration is greek' do
        let(:name) { 'Μαγειρέματα και Κουρέματα' }
        let(:slug) { nil }
        let(:transliterations) { 'greek' }

        it { expect(model.displayed_slug(transliterations)).to eq('mageiremata-kai-koyremata') }
      end
    end
  end
end
