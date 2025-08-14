# frozen_string_literal: true

module Admin
  # The admin user password controller
  class PasswordController < BaseController
    before_action :fetch_user

    # GET /admin/password/edit
    def edit; end

    # PUT /admin/password/edit
    # PATCH /admin/password/edit
    def update
      if @user.update_with_password(user_params)
        redirect_to admin_root_path, notice: _('Your password was successfully changed.')
      else
        render :edit
      end
    end

    private

    def fetch_user
      @user = AdminUser.find(current_admin_user.id)
    end

    def user_params
      params.expect(admin_user: %i[current_password password password_confirmation])
    end
  end
end
