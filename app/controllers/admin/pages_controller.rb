# frozen_string_literal: true

module Admin
  # Admin pages controller
  class PagesController < BaseController
    PAGE_SIZE = 10

    before_action :fetch_page, only: %i[show edit update destroy translate save_translation publish]
    before_action :fetch_translation, only: %i[translate save_translation]
    before_action :fetch_templates, only: %i[new edit create update]
    before_action :fetch_visibilities, only: %i[new edit create update]

    decorates_assigned :pages

    # GET /pages
    # GET /tag/:tag_id/pages
    # GET /user/:user_id/pages
    def index
      user_id = params[:user_id]
      user_id ||= current_admin_user.id if params[:only_mine].present?

      @pages = Page.includes(:translations).where(client_id: current_client.id)
      @pages = @pages.where(status: params[:status]) if params[:status].present?
      @pages = @pages.joins(:tag_taggables).where(tag_taggables: { tag_id: params[:tag_id] }) if params[:tag_id].present?
      @pages = @pages.where(author_id: user_id) if user_id.present?
      @pages = @pages.where(parent_id: params[:parent_id]) if params[:parent_id].present?

      @pages = @pages.simple_text_search(params[:search])
                     .bound_sort(params[:sort_by], params[:dir])
                     .page(params[:page].to_i)
                     .per(PAGE_SIZE)
      render :_pages_table, layout: nil if request.xhr?
    end

    # GET /pages/tree
    # GET /pages/tree.json
    def tree
      @pages = Page.ordered_by_hierarchy(Page.includes(:translations).where(client_id: current_client.id))
    end

    # GET /pages/search
    # GET /pages/search.json
    def search
      pages = Page.where(client_id: current_client.id)
      if params[:excluded_id].present?
        excluded_page = Page.find_by!(id: params[:excluded_id], client_id: current_client.id)
        pages = pages.where.not(id: excluded_page.id).where.not(id: Page.descendants_of(excluded_page))
      end

      pages = pages.simple_text_search(params[:term])
                   .bound_sort(params[:sort_by] || 'name', params[:dir])
                   .select(:id, :name)
                   .page(params[:page].to_i)
                   .per(PAGE_SIZE)
      results = pages.map { |page| { id: page.id, text: page.name } }
      more = !pages.last_page? && results.any?

      render json: { results:, pagination: { more: } }
    end

    # GET /pages/1/show
    # GET /pages/1/show.json
    def show; end

    # GET /pages/new
    def new
      @page = Page.new
      @page.parent_id = params[:parent_id]
    end

    # GET /pages/1/edit
    # GET /pages/1/edit.json
    def edit
      @page.tag_names = @page.tags.map(&:name)
    end

    # POST /pages
    # POST /pages.json
    def create
      @page = Page.new(page_params)
      @page.client_id = current_client.id
      @page.author_id = current_admin_user.id
      @page.should_save_tags = true

      result = params[:publish].present? ? @page.publish_now : @page.save

      if result
        CacheVersionBumper.call(current_client.id)
        redirect_to admin_page_path(@page), notice: _('The page was successfully created.')
      else
        render :new
      end
    end

    # PATCH/PUT /pages
    # PATCH/PUT /pages.json
    def update
      default_params = { parent_id: nil }

      @page.assign_attributes(default_params.merge(page_params))
      @page.should_save_tags = true

      result = params[:publish].present? ? @page.publish_now : @page.save

      if result
        CacheVersionBumper.call(current_client.id)
        redirect_to admin_page_path(@page), notice: _('The page was successfully updated.')
      else
        render :edit
      end
    end

    # DELETE /pages/1
    # DELETE /pages/1.json
    def destroy
      @page.destroy
      CacheVersionBumper.call(current_client.id)

      redirect_to admin_pages_path, notice: _('The page was successfully deleted.')
    end

    # POST /pages/1/publish
    # POST /pages/2/publish.json
    def publish
      if @page.publish_now
        CacheVersionBumper.call(current_client.id)
        redirect_to admin_page_path(@page), notice: _('The page was successfully published.')
      else
        redirect_to admin_page_path(@page), alert: _('The page could not be published.')
      end
    end

    # GET /pages/1/translate
    def translate; end

    # POST /pages/1/translate
    def save_translation
      @page.assign_attributes(translation_params)

      if @page.save_translation(translation_locale)
        CacheVersionBumper.call(current_client.id)
        redirect_to translate_admin_page_path(@page, translation_locale:),
                    notice: _('The page was successfully translated.')
      else
        @translation.assign_attributes(translation_params)

        render :translate
      end
    end

    private

    def fetch_page
      @page = Page.find_by!(id: params[:id], client_id: current_client.id).decorate
    end

    def fetch_translation
      @translation = @page.translate(translation_locale)
    end

    def fetch_templates
      path = Rails.root.join("app/views/templates/#{current_client.template}/pages/*.html.erb")
      @templates = Dir[path].map { |f| File.basename(f, '.html.erb') }
                            .reject { |f| f.start_with?('_') }
                            .sort
    end

    def fetch_visibilities
      @visibilities = [[_('Public|Visibility'), :public], [_('Private|Visibility'), :private]]
    end

    def page_params
      params.expect(page: [:image, :should_remove_image, :name, :slug, :description, :body,
                           :visibility, :template, :parent_id, { tag_names: [] }])
    end

    def translation_params
      params.expect(page: [Page::TRANSLATABLE_FIELDS])
    end
  end
end
