# frozen_string_literal: true

RSpec.shared_examples 'SimpleTextSearchable' do
  described_class::TEXT_SEARCHABLE_FIELDS.each do |field|
    context "when searching for :#{field}" do
      context 'when a model does not qualify' do
        it 'is not included in the results' do
          expect(described_class.simple_text_search('invalid')).not_to include(*model)
        end
      end

      context 'when a model qualifies' do
        it 'is included in the results' do
          expect(described_class.simple_text_search(model[field])).to contain_exactly(model)
        end
      end
    end
  end
end
