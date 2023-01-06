# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Language do
  subject { build(:language) }

  it { is_expected.to have_many(:client_languages).dependent(:destroy) }
end
