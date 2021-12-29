# frozen_string_literal: true

module Admin
  # The media controller
  class MediaController < BaseController
    PAGE_SIZE = 10

    before_action :fetch_medium, only: :destroy

    # GET /admin/media
    # GET /admin/media.json
    def index
      @media = Medium.includes(file_attachment: :blob)
                     .where(client_id: current_client.id)
                     .simple_text_search(params[:search])
                     .bound_sort(params[:sort_by], params[:dir])
                     .page(params[:page].to_i)
                     .per(PAGE_SIZE)
      render :_media_table, layout: nil if request.xhr?
    end

    # POST /admin/media
    # POST /admin/media.json
    def create
      media = ActiveRecord::Base.transaction do
        media_files.map do |file|
          medium = Medium.new({ file: file })
          medium.client_id = current_client.id

          raise ActiveRecord::Rollback unless medium.save

          medium
        end
      end

      if media.nil?
        redirect_to admin_media_path, alert: _('An error occurred. Please try again later.')
      elsif media.empty?
        redirect_to admin_media_path, alert: _('Media files are required.')
      else
        notice = format(n_('%<total>i medium was successfully created.', '%<total>i media were successfully created.', media.size), total: media.size)

        redirect_to admin_media_path, notice: notice
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
      @medium = Medium.find_by!(id: params[:id], client_id: current_client.id)
    end

    def media_files
      params.require(:medium).permit(file: []).fetch(:file, [])
    end
  end
end
