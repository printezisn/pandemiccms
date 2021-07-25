# frozen_string_literal: true

module Admin
  # Admin tags controller
  class TagsController < BaseController
    PAGE_SIZE = 10

    before_action :fetch_tag, only: %i[show edit update destroy translate save_translation]
    before_action :fetch_translation, only: %i[translate save_translation]
    before_action :fetch_templates, only: %i[new edit create update]
    before_action :fetch_visibilities, only: %i[new edit create update]

    decorates_assigned :tags

    # GET /tags
    # GET /tags.json
    def index
      @tags = Tag.where(client_id: current_client.id)
                 .simple_text_search(params[:search])
                 .bound_sort(params[:sort_by], params[:dir])
                 .page(params[:page].to_i)
                 .per(PAGE_SIZE)
      render :_tags_table, layout: nil if request.xhr?
    end

    # GET /tags/1
    # GET /tags/1.json
    def show; end

    # GET /tags/new
    def new
      @tag = Tag.new
    end

    # GET /tags/1/edit
    def edit; end

    # POST /tags
    # POST /tags.json
    def create
      @tag = Tag.new(tag_params)
      @tag.client_id = current_client.id

      if @tag.save
        CacheVersionBumper.call(current_client.id)
        redirect_to admin_tag_path(@tag), notice: _('The tag was successfully created.')
      else
        render :new
      end
    end

    # PATCH/PUT /tags/1
    # PATCH/PUT /tags/1.json
    def update
      if @tag.update(tag_params)
        CacheVersionBumper.call(current_client.id)
        redirect_to admin_tag_path(@tag), notice: _('The tag was successfully updated.')
      else
        render :edit
      end
    end

    # DELETE /tags/1
    # DELETE /tags/1.json
    def destroy
      @tag.destroy
      CacheVersionBumper.call(current_client.id)

      redirect_to admin_tags_path, notice: _('The tag was successfully deleted.')
    end

    # GET /tags/1/translate
    def translate; end

    # POST /tags/1/translate
    def save_translation
      @tag.assign_attributes(translation_params)

      if @tag.save_translation(translation_locale)
        CacheVersionBumper.call(current_client.id)
        redirect_to translate_admin_tag_path(@tag, translation_locale: translation_locale),
                    notice: _('The tag was successfully translated.')
      else
        @translation.assign_attributes(translation_params)

        render :translate
      end
    end

    # GET /tags/search
    # GET /tags/search.json
    def search
      tags = Tag.where(client_id: current_client.id)
                .simple_text_search(params[:term])
                .bound_sort(params[:sort_by] || 'name', params[:dir])
                .select(:id, :name)
                .page(params[:page].to_i)
                .per(PAGE_SIZE)
      results = tags.map { |tag| { id: tag.id, text: tag.name } }
      more = !tags.last_page? && results.any?

      render json: { results: results, pagination: { more: more } }
    end

    private

    def fetch_tag
      @tag = Tag.find_by!(id: params[:id], client_id: current_client.id).decorate
    end

    def fetch_translation
      @translation = @tag.translate(translation_locale)
    end

    def fetch_templates
      path = Rails.root.join("app/views/templates/#{current_client.template}/tags/*.html.erb")
      @templates = Dir[path].map { |f| File.basename(f, '.html.erb') }
                            .reject { |f| f.start_with?('_') }
                            .sort
    end

    def fetch_visibilities
      @visibilities = [[_('Public|Visibility'), :public], [_('Private|Visibility'), :private]]
    end

    def tag_params
      params.require(:tag).permit(:name, :slug, :description, :body, :template, :visibility)
    end

    def translation_params
      params.require(:tag).permit(Tag::TRANSLATABLE_FIELDS)
    end
  end
end
