# frozen_string_literal: true

RSpec.shared_examples 'Translatable' do
  it { is_expected.to have_many(:translations).dependent(:destroy) }

  def translatable_fields(object)
    object.attributes.slice(*described_class::TRANSLATABLE_FIELDS)
  end

  describe '#save_translation' do
    before { model.assign_attributes(translatable_fields(translation)) }

    it 'saves the translation' do
      expect { model.save_translation(:en) }.to change(model.translations, :count).by(1)
    end

    it 'does not affect the model' do
      model.save_translation(:en)

      expect(translatable_fields(model)).not_to eq(translatable_fields(translation))
    end
  end

  describe '#translate' do
    before do
      model.assign_attributes(translatable_fields(translation))
      model.save_translation(:en)
    end

    it 'translates fields' do
      expect(translatable_fields(model.translate(:en))).to eq(translatable_fields(translation))
    end
  end
end
