# frozen_string_literal: true

RSpec.shared_examples 'Imageable' do
  let(:file) do
    {
      io: Rails.root.join('spec/fixtures/test.png').open,
      filename: 'test.png'
    }
  end

  it 'updates the image of model' do
    expect do
      model.image.attach(file)
      model.save!
    end.to change { model.image.attached? }.from(false).to(true)
  end

  context 'when it should remove the image' do
    before do
      model.image.attach(file)
      model.save!
    end

    it 'removes the image' do
      expect do
        model.update!(should_remove_image: true)
      end.to change { model.image.attached? }.from(true).to(false)
    end
  end
end
