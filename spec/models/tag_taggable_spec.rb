# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TagTaggable, type: :model do
  subject { FactoryBot.build(:tag_taggable) }

  it { is_expected.to belong_to(:tag) }
  it { is_expected.to belong_to(:taggable) }
end
