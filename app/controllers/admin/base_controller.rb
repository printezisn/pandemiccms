# frozen_string_literal: true

module Admin
  # Base admin controller
  class BaseController < ::ApplicationController
    before_action :authenticate_admin_user!

    def layout
      'admin'
    end
  end
end
