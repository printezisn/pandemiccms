# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Slugifier do
  subject(:service_call) { described_class.call(str) }

  let(:str) { 'this is a Content' }
  let(:result) { 'this-is-a-content' }

  context 'when the string is latin' do
    it { is_expected.to eq(result) }
  end

  context 'when the string is greek' do
    let(:str) { 'Μαγειρέματα και Κουρέματα' }
    let(:result) { 'mageiremata-kai-koyremata' }

    it { is_expected.to eq(result) }
  end
end
