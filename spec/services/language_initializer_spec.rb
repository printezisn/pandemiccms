# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LanguageInitializer do
  subject(:service_call) { described_class.call }

  it { expect { service_call }.to change { Language.pluck(:locale).sort }.from([]).to(%w[el-GR en-GB]) }
end
