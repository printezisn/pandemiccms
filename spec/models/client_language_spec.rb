# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ClientLanguage do
  subject { build(:client_language) }

  it { is_expected.to belong_to(:client) }
  it { is_expected.to belong_to(:language) }
end
