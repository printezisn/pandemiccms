# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Translation do
  subject { build(:translation) }

  it { is_expected.to belong_to(:translatable) }

  it { is_expected.to serialize(:fields) }
end
