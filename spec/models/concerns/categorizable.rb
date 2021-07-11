# frozen_string_literal: true

RSpec.shared_examples 'Categorizable' do
  it { is_expected.to have_many(:category_categorizables).dependent(:destroy) }
  it { is_expected.to have_many(:categories).through(:category_categorizables) }

  describe '#save_categories' do
    let(:initial_category) { FactoryBot.create(:category) }

    before { model.categories = [initial_category] }

    context 'when an additional category is added' do
      let(:new_category_names) { [initial_category.name, 'New Test Category'] }

      it 'creates a new category' do
        expect do
          model.update!(should_save_categories: true, category_names: new_category_names)
        end.to change(Category, :count).by(1)
      end

      it 'adds the new category to the model' do
        expect do
          model.update!(should_save_categories: true, category_names: new_category_names)
        end.to change { model.categories.map(&:name) }.from([initial_category.name]).to(new_category_names)
      end
    end

    context 'when an existing category is removed' do
      let(:new_category_names) { [] }

      it 'removes the category from the model' do
        expect do
          model.update!(should_save_categories: true, category_names: new_category_names)
        end.to change { model.categories.map(&:name) }.from([initial_category.name]).to(new_category_names)
      end
    end

    context 'when an existing category is removed and another one is added' do
      let(:new_category_names) { ['New Test Category'] }

      it 'creates a new category' do
        expect do
          model.update!(should_save_categories: true, category_names: new_category_names)
        end.to change(Category, :count).by(1)
      end

      it 'removes the existing category from the model and adds the new one' do
        expect do
          model.update!(should_save_categories: true, category_names: new_category_names)
        end.to change { model.categories.map(&:name) }.from([initial_category.name]).to(new_category_names)
      end
    end

    context 'when categories should not be saved' do
      let(:new_category_names) { [initial_category.name, 'New Test Category'] }

      it 'does not create a new category' do
        expect do
          model.update!(should_save_categories: false, category_names: new_category_names)
        end.not_to change(Category, :count)
      end

      it 'does not change the categories of the model' do
        expect do
          model.update!(should_save_categories: false, category_names: new_category_names)
        end.not_to change { model.categories.map(&:name) }.from([initial_category.name])
      end
    end
  end
end
