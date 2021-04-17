# frozen_string_literal: true

module Admin
  # Clients controller
  class ClientsController < BaseSupervisorController
    before_action :fetch_client
    before_action :fetch_languages

    # GET /client/edit
    def edit; end

    # PUT /client/edit
    # PATCH /client/edit
    def update
      saved = ActiveRecord::Base.transaction do
        language_ids = params.fetch(:language_ids, [])
        default_language_id = params.fetch(:default_language_id)
        @client.client_languages.each do |cl|
          raise ActiveRecord::Rollback unless cl.update(
            enabled: language_ids.include?(cl.id.to_s),
            default: cl.id.to_s == default_language_id
          )
        end

        @client.update(client_params)
      end.present?

      if saved
        redirect_to admin_client_edit_path, notice: _('The settings were successfully updated.')
      else
        render :edit
      end
    end

    private

    def fetch_client
      @client = Client.find(current_client.id)
    end

    def fetch_languages
      @languages = @client.client_languages.includes(:language)
    end

    def client_params
      params.require(:client).permit(:image, :should_remove_image, :name, :email, :time_zone, :cache_enabled, :cache_duration)
    end
  end
end
