# frozen_string_literal: true

RSpec.shared_examples 'Draftable' do
  it { is_expected.to define_enum_for(:status).with_values(draft: 0, published: 1) }

  describe '#publish_now' do
    context 'when it is already published' do
      before { model.published! }

      it 'returns false' do
        expect(model.publish_now).to be_falsey
      end

      it 'does not update the status' do
        expect { model.publish_now }.not_to change { model.reload.status }.from('published')
      end
    end

    context 'when it is not published' do
      let(:time) { Time.zone.now.round }

      before { Timecop.freeze(time) }

      after { Timecop.return }

      it 'returns true' do
        expect(model.publish_now).to be_truthy
      end

      it 'updates the status' do
        expect { model.publish_now }.to(
          change { [model.reload.status, model.reload.published_at] }.from(['draft', nil]).to(['published', time.utc])
        )
      end
    end
  end
end
