# frozen_string_literal: true

# Base admin controller
module Admin
  class BaseController < ::ApplicationController
    before_action :authenticate_admin_user!

    def layout
      'admin'
    end
  end
end
