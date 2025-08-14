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
        media_files.compact_blank.map do |file|
          medium = Medium.new({ file: })
          medium.client_id = current_client.id

          raise ActiveRecord::Rollback unless medium.save

          medium
        end
      end

      if media.nil?
        respond_to do |format|
          format.html { redirect_to admin_media_path, alert: _('An error occurred. Please try again later.') }
          format.json { render json: { error: _('An error occurred. Please try again later.') } }
        end
      elsif media.empty?
        respond_to do |format|
          format.html { redirect_to admin_media_path, alert: _('Media files are required.') }
          format.json { render json: { error: _('Media files are required.') } }
        end
      else
        respond_to do |format|
          format.html do
            notice = format(
              n_('%<total>i medium was successfully created.', '%<total>i media were successfully created.', media.size),
              total: media.size
            )

            redirect_to admin_media_path, notice:
          end

          format.json do
            render json: { url: rails_blob_url(media.first.file) }
          end
        end
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
      params.expect(medium: [file: []]).fetch(:file, [])
    end
  end
end
