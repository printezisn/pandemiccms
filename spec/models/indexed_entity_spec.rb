# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IndexedEntity do
  subject { build(:indexed_entity) }

  it { is_expected.to belong_to(:indexable) }
  it { is_expected.to belong_to(:client) }
end
