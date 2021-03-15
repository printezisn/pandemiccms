# frozen_string_literal: true

RSpec.shared_examples 'Taggable' do
  it { is_expected.to have_many(:tag_taggables).dependent(:destroy) }
  it { is_expected.to have_many(:tags).through(:tag_taggables) }

  describe '#save_tags' do
    let(:initial_tag) { FactoryBot.create(:tag) }

    before { model.tags = [initial_tag] }

    context 'when an additional tag is added' do
      let(:new_tag_names) { [initial_tag.name, 'New Test Tag'] }

      it 'creates a new tag' do
        expect do
          model.update!(should_save_tags: true, tag_names: new_tag_names)
        end.to change(Tag, :count).by(1)
      end

      it 'adds the new tag to the model' do
        expect do
          model.update!(should_save_tags: true, tag_names: new_tag_names)
        end.to change { model.reload.tags.map(&:name) }.from([initial_tag.name]).to(new_tag_names)
      end
    end

    context 'when an existing tag is removed' do
      let(:new_tag_names) { [] }

      it 'removes the tag from the model' do
        expect do
          model.update!(should_save_tags: true, tag_names: new_tag_names)
        end.to change { model.reload.tags.map(&:name) }.from([initial_tag.name]).to(new_tag_names)
      end
    end

    context 'when an existing tag is removed and another one is added' do
      let(:new_tag_names) { ['New Test Tag'] }

      it 'creates a new tag' do
        expect do
          model.update!(should_save_tags: true, tag_names: new_tag_names)
        end.to change(Tag, :count).by(1)
      end

      it 'removes the existing tag from the model and adds the new one' do
        expect do
          model.update!(should_save_tags: true, tag_names: new_tag_names)
        end.to change { model.reload.tags.map(&:name) }.from([initial_tag.name]).to(new_tag_names)
      end
    end

    context 'when tags should not be saved' do
      let(:new_tag_names) { [initial_tag.name, 'New Test Tag'] }

      it 'does not create a new tag' do
        expect do
          model.update!(should_save_tags: false, tag_names: new_tag_names)
        end.not_to change(Tag, :count)
      end

      it 'does not change the tags of the model' do
        expect do
          model.update!(should_save_tags: false, tag_names: new_tag_names)
        end.not_to change { model.reload.tags.map(&:name) }.from([initial_tag.name])
      end
    end
  end
end
