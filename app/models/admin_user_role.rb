# frozen_string_literal: true

class AdminUserRole < ApplicationRecord
  belongs_to :admin_user

  enum role: {
    supervisor: 0
  }
end
