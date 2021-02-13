# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdminUser, type: :model do
  subject(:model) { FactoryBot.build(:admin_user) }

  it { is_expected.to belong_to(:client) }

  it { is_expected.to have_many(:admin_user_roles).dependent(:destroy) }

  it { is_expected.to have_many(:created_tags).class_name('Tag').dependent(:destroy) }

  it { is_expected.to have_many(:updated_tags).class_name('Tag').dependent(:destroy) }

  # Username
  it { is_expected.to validate_presence_of(:username).with_message('The username is required.') }
  it { is_expected.to allow_value('test.-usER0').for(:username) }

  it do
    expect(model).not_to allow_value('test@user')
      .for(:username)
      .with_message('The username must contain only letters, digits, dashes and dots.')
  end

  it do
    expect(model).to validate_length_of(:username)
      .is_at_most(50)
      .with_message('The username may contain up to 50 characters.')
  end

  it do
    expect(model).to validate_uniqueness_of(:username)
      .case_insensitive
      .scoped_to([:client_id])
      .with_message('The username is already used.')
  end

  # Email
  it { is_expected.to validate_presence_of(:email).with_message('The email is required.') }
  it { is_expected.to allow_value('test@test.com').for(:email) }

  it do
    expect(model).not_to allow_value('testuser')
      .for(:email)
      .with_message('The email format is invalid.')
  end

  it do
    expect(model).to validate_length_of(:email)
      .is_at_most(255)
      .with_message('The email may contain up to 255 characters.')
  end

  it do
    expect(model).to validate_uniqueness_of(:email)
      .case_insensitive
      .scoped_to([:client_id])
      .with_message('The email is already used.')
  end

  # Password
  it { is_expected.to validate_presence_of(:password).with_message('The password is required.') }
  it { is_expected.to allow_value('T3$tPa$$').for(:password) }

  it do
    expect(model).not_to allow_value('test1234')
      .for(:password)
      .with_message('The password must contain at least 1 upper case character, 1 lower case, 1 digit and 1 symbol.')
  end

  it do
    expect(model).to validate_length_of(:password)
      .is_at_most(128)
      .with_message('The password may contain up to 128 characters.')
  end

  # Password confirmation
  it do
    expect(model).to validate_confirmation_of(:password)
      .with_message('Password confirmation must match the password.')
  end

  # First name
  it { is_expected.to validate_length_of(:first_name).is_at_most(255).with_message('The first name may contain up to 255 characters.') }

  # Middle name
  it { is_expected.to validate_length_of(:middle_name).is_at_most(255).with_message('The middle name may contain up to 255 characters.') }

  # Last name
  it { is_expected.to validate_length_of(:last_name).is_at_most(255).with_message('The last name may contain up to 255 characters.') }

  describe '#full_name' do
    context 'with middle name' do
      it { expect(model.full_name).to eq("#{model.first_name} #{model.middle_name} #{model.last_name}") }
    end

    context 'without middle name' do
      subject(:model) { FactoryBot.build(:admin_user, middle_name: '') }

      it { expect(model.full_name).to eq("#{model.first_name} #{model.last_name}") }
    end
  end

  describe '#supervisor?' do
    context 'when the user does not have a supervisor role' do
      it { is_expected.not_to be_supervisor }
    end

    context 'when the user has a supervisor role' do
      subject(:model) { FactoryBot.create(:admin_user, :supervisor) }

      it { is_expected.to be_supervisor }
    end
  end
end
