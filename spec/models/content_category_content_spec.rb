# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContentCategoryContent do
  subject { build(:content_category_content) }

  it { is_expected.to belong_to(:content_category).inverse_of(:content_category_contents) }
  it { is_expected.to belong_to(:content).inverse_of(:content_category_contents) }
end
