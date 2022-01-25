# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdminUserRole, type: :model do
  subject { build(:admin_user_role) }

  it { is_expected.to belong_to(:admin_user) }
  it { is_expected.to define_enum_for(:role).with_values({ supervisor: 0 }) }
end
