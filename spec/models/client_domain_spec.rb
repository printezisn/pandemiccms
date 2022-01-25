# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ClientDomain, type: :model do
  subject { build(:client_domain) }

  it { is_expected.to belong_to(:client) }
end
