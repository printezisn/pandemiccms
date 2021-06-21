# frozen_string_literal: true

module Admin
  # The admin user profile controller
  class ProfileController < BaseController
    before_action :fetch_user
    before_action :fetch_translation, only: %i[translate save_translation]

    # GET /profile
    def index; end

    # GET /profile/edit
    def edit; end

    # PUT /profile/edit
    # PATCH /profile/edit
    def update
      if @user.update(user_params)
        CacheVersionBumper.call(current_client.id)
        redirect_to admin_profile_path, notice: _('Your profile was successfully updated.')
      else
        render :edit
      end
    end

    # GET /profile/translate
    def translate; end

    # POST /profile/translate
    def save_translation
      @user.assign_attributes(translation_params)

      if @user.save_translation(translation_locale)
        CacheVersionBumper.call(current_client.id)
        redirect_to admin_profile_translate_path(translation_locale: translation_locale),
                    notice: _('Your profile was successfully translated.')
      else
        @translation.assign_attributes(translation_params)

        render :translate
      end
    end

    private

    def fetch_user
      @user = AdminUser.find(current_admin_user.id)
    end

    def fetch_translation
      @translation = @user.translate(translation_locale)
    end

    def user_params
      params.require(:admin_user).permit(:image, :should_remove_image, :email, :first_name,
                                         :middle_name, :last_name, :description)
    end

    def translation_params
      params.require(:admin_user).permit(AdminUser::TRANSLATABLE_FIELDS)
    end
  end
end
