# frozen_string_literal: true

RSpec.shared_examples 'BoundSortable' do
  described_class::SORTABLE_FIELDS.each do |field|
    context "when sorting by :#{field}" do
      it 'returns the correct results' do
        expect(described_class.bound_sort(field, 'desc')).to include(model)
      end
    end
  end
end
