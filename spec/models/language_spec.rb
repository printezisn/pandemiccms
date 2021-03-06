# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Language, type: :model do
  subject { FactoryBot.build(:language) }

  it { is_expected.to have_many(:client_languages).dependent(:destroy) }
end
