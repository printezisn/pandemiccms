# frozen_string_literal: true

module Admin
  # Admin contents controller
  class ContentsController < BaseController
    PAGE_SIZE = 10

    before_action :fetch_content, only: %i[show edit update destroy translate save_translation]
    before_action :fetch_translation, only: %i[translate save_translation]

    # GET /contents
    # GET /content_category/:category_id/contents
    def index
      @contents = Content.includes(:translations).where(client_id: current_client.id)
      if params[:category_id].present?
        @contents = @contents.joins(:content_category_contents).where(content_category_contents: { content_category_id: params[:category_id] })
      end

      @contents = @contents.simple_text_search(params[:search])
                           .bound_sort(params[:sort_by], params[:dir])
                           .page(params[:page].to_i)
                           .per(PAGE_SIZE)
      render :_contents_table, layout: nil if request.xhr?
    end

    # GET /contents/1/show
    # GET /contents/1/show.json
    def show; end

    # GET /contents/new
    def new
      @content = Content.new
    end

    # GET /contents/1/edit
    # GET /contents/1/edit.json
    def edit
      @content.category_names = @content.categories.map(&:name)
    end

    # POST /contents
    # POST /contents.json
    def create
      @content = Content.new(content_params)
      @content.client_id = current_client.id
      @content.should_save_categories = true

      if @content.save
        CacheVersionBumper.call(current_client.id)
        redirect_to admin_content_path(@content), notice: _('The content was successfully created.')
      else
        render :new
      end
    end

    # PATCH/PUT /contents
    # PATCH/PUT /contents.json
    def update
      @content.assign_attributes(content_params)
      @content.should_save_categories = true

      if @content.save
        CacheVersionBumper.call(current_client.id)
        redirect_to admin_content_path(@content), notice: _('The content was successfully updated.')
      else
        render :edit
      end
    end

    # DELETE /contents/1
    # DELETE /contents/1.json
    def destroy
      @content.destroy
      CacheVersionBumper.call(current_client.id)

      redirect_to admin_contents_path, notice: _('The content was successfully deleted.')
    end

    # GET /contents/1/translate
    def translate; end

    # POST /contents/1/translate
    def save_translation
      @content.assign_attributes(translation_params)

      if @content.save_translation(translation_locale)
        CacheVersionBumper.call(current_client.id)
        redirect_to translate_admin_content_path(@content, translation_locale:),
                    notice: _('The content was successfully translated.')
      else
        @translation.assign_attributes(translation_params)

        render :translate
      end
    end

    private

    def fetch_content
      @content = Content.find_by!(id: params[:id], client_id: current_client.id)
    end

    def fetch_translation
      @translation = @content.translate(translation_locale)
    end

    def content_params
      params.expect(content: [:image, :should_remove_image, :name, :order, :simple_text, :rich_text,
                              { category_names: [] }])
    end

    def translation_params
      params.expect(content: Content::TRANSLATABLE_FIELDS)
    end
  end
end
