# frozen_string_literal: true

# Admin user role model
class AdminUserRole < ApplicationRecord
  belongs_to :admin_user

  enum role: {
    supervisor: 0
  }
end
