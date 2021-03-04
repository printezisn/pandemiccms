# frozen_string_literal: true

RSpec.shared_examples 'Parentable' do
  describe '#hierarchy_path' do
    it 'is the comma-separated list of ancestors' do
      expect(model.parent.hierarchy_path).to be_nil
      expect(model.hierarchy_path).to eq(model.parent_id.to_s)
      expect(model.children[0].hierarchy_path).to eq("#{model.parent_id},#{model.id}")
      expect(model.children[1].hierarchy_path).to eq("#{model.parent_id},#{model.id}")
    end
  end

  describe '#valid_parent' do
    context 'when the parent is not found' do
      before do
        model.parent_id = -1
        model.validate
      end

      it { expect(model.errors.messages[:parent_id]).to contain_exactly('The parent was not found.') }
    end
  end

  describe '#valid_hierarchy' do
    context 'when no circle is found' do
      let(:child) { model.children[0] }

      before { child.parent_id = model.parent_id }

      it { expect(child).to be_valid }
    end

    context 'when a circle is found' do
      let(:child) { model.children[0] }

      before do
        model.parent.parent_id = model.children[0].id
        model.parent.validate
      end

      it { expect(model.parent.errors.messages[:parent_id]).to contain_exactly('The parent is invalid. A circle was detected in the hierarchy.') }
    end
  end

  describe '#ancestor_ids' do
    it { expect(model.children[0].ancestor_ids).to eq([model.parent.id, model.id]) }
  end

  describe '#ancestors' do
    it { expect(model.children[0].ancestors.map(&:id)).to eq([model.parent.id, model.id]) }
  end

  describe '#descendants' do
    it { expect(model.parent.descendants.map(&:id)).to contain_exactly(model.id, model.children[0].id, model.children[1].id) }
  end

  describe '#depth' do
    it { expect(model.depth).to eq(1) }
  end

  describe '#name_with_depth' do
    context 'when depth is 0' do
      it { expect(model.parent.name_with_depth).to eq(model.parent.name) }
    end

    context 'when depth is greater than 0' do
      it { expect(model.name_with_depth).to eq("-- #{model.name}") }
    end
  end

  describe '.ordered_by_hierarchy' do
    context 'when an excluded instance is passed' do
      subject(:hierarchy) do
        described_class.ordered_by_hierarchy(model.client_id, model).map(&:id)
      end

      it 'does not include the excluded instance and its descendants' do
        expect(hierarchy).to eq([model.parent_id])
      end
    end

    context 'when an excluded instance is not passed' do
      subject(:hierarchy) do
        described_class.ordered_by_hierarchy(model.client_id, nil).map(&:id)
      end

      it 'includes all instances' do
        expect(hierarchy).to eq([model.parent_id, model.id, model.children[0].id, model.children[1].id])
      end
    end
  end
end
