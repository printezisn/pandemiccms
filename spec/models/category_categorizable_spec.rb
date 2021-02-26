# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CategoryCategorizable, type: :model do
  subject { FactoryBot.build(:category_categorizable) }

  it { is_expected.to belong_to(:category) }
  it { is_expected.to belong_to(:categorizable) }
end
