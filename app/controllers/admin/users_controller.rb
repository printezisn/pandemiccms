# frozen_string_literal: true

module Admin
  # Admin users controller
  class UsersController < BaseController
    PAGE_SIZE = 10

    before_action :require_supervisor
    before_action :fetch_user, except: %i[index new create]
    before_action :fetch_roles, only: %i[new create edit update]
    before_action :fetch_translation, only: %i[translate save_translation]

    # GET /users
    # GET /users.json
    def index
      @users = AdminUser.where(client_id: current_client.id)
                        .simple_text_search(params[:search])
                        .bound_sort(params[:sort_by], params[:dir])
                        .page(params[:page].to_i)
                        .per(PAGE_SIZE)
      render :_users_table, layout: nil if request.xhr?
    end

    # GET /users/1
    def show; end

    # GET /users/new
    def new
      @user = AdminUser.new
    end

    # GET /users/1/edit
    def edit; end

    # POST /users
    def create
      @user = AdminUser.new(create_params)
      @user.should_set_roles = true
      @user.client_id = current_client.id
      @user.set_random_password if @user.password.blank?

      if @user.save
        redirect_to admin_user_path(@user), notice: _('The user was successfully created.')
      else
        render :new
      end
    end

    # PATCH/PUT /users/1
    def update
      if @user.update(update_params)
        CacheVersionBumper.call(current_client.id)
        redirect_to admin_user_path(@user), notice: _('The user was successfully updated.')
      else
        render :edit
      end
    end

    # DELETE /users/1
    def destroy
      @user.destroy

      redirect_to admin_users_path, notice: _('The user was successfully deleted.')
    end

    # DELETE /users/1
    def activate
      @user.active!

      redirect_to admin_user_path(@user), notice: _('The user was successfully activated.')
    end

    # POST /users/
    def deactivate
      @user.inactive!

      redirect_to admin_user_path(@user), notice: _('The user was successfully deactivated.')
    end

    # GET /users/1/translate
    def translate; end

    # POST /users/1/translate
    def save_translation
      @user.assign_attributes(translation_params)

      if @user.save_translation(translation_locale)
        CacheVersionBumper.call(current_client.id)
        redirect_to translate_admin_user_path(@user, translation_locale:),
                    notice: _('The user was successfully translated.')
      else
        @translation.assign_attributes(translation_params)

        render :translate
      end
    end

    private

    def fetch_user
      @user = AdminUser.find_by!(id: params[:id], client_id: current_client.id)
      @user.role = @user.admin_user_roles.first&.role
      @user.should_set_roles = true
    end

    def fetch_roles
      @roles = [[_('Supervisor'), :supervisor]]
    end

    def fetch_translation
      @translation = @user.translate(translation_locale)
    end

    def create_params
      params.expect(admin_user: %i[image should_remove_image username email role first_name
                                   middle_name last_name description password password_confirmation])
    end

    def update_params
      params.expect(admin_user: %i[image should_remove_image email role first_name middle_name
                                   last_name description])
    end

    def translation_params
      params.expect(admin_user: [AdminUser::TRANSLATABLE_FIELDS])
    end
  end
end
