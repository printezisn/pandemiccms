# frozen_string_literal: true

module Admin
  # The media controller
  class MediaController < BaseController
    PAGE_SIZE = 10

    before_action :fetch_medium, only: :destroy

    # GET /admin/media
    # GET /admin/media.json
    def index
      @media = Medium.where(client_id: current_client[:id])
                     .simple_text_search(params[:search])
                     .bound_sort(params[:sort_by], params[:dir])
                     .page(params[:page].to_i)
                     .per(PAGE_SIZE)
    end

    # POST /admin/media
    # POST /admin/media.json
    def create
      @medium = Medium.new(medium_params)
      @medium.client_id = current_client[:id]

      if @medium.save
        redirect_to admin_media_path, notice: _('The medium was successfully created.')
      else
        redirect_to admin_media_path, alert: _('An error occurred. Please try again later.')
      end
    end

    # DELETE /admin/media/1
    # DELETE /admin/media/1.json
    def destroy
      @medium.destroy

      redirect_to admin_media_path, notice: _('The medium was successfully deleted.')
    end

    private

    def fetch_medium
      @medium = Medium.find_by(id: params[:id], client_id: current_client[:id])
    end

    def medium_params
      params.require(:medium).permit(:file)
    end
  end
end
