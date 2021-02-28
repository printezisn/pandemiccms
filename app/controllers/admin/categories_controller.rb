# frozen_string_literal: true

module Admin
  # Admin categories controller
  class CategoriesController < BaseController
    PAGE_SIZE = 10

    before_action :fetch_category, only: %i[show edit update destroy translate save_translation]
    before_action :fetch_translation, only: %i[translate save_translation]
    before_action :fetch_templates, only: %i[new edit create update]

    # GET /categories
    # GET /categories.json
    def index
      @categories = Category.where(client_id: current_client.id)
                            .simple_text_search(params[:search])
                            .bound_sort(params[:sort_by], params[:dir])
                            .page(params[:page].to_i)
                            .per(PAGE_SIZE)
      render :_categories_table, layout: nil if request.xhr?
    end

    # GET /categories/1/children
    # GET /categories/1/children.json
    def children
      @categories = Category.where(client_id: current_client.id, parent_id: params[:id])
                            .simple_text_search(params[:search])
                            .bound_sort(params[:sort_by], params[:dir])
                            .page(params[:page].to_i)
                            .per(PAGE_SIZE)
      render :children, layout: nil
    end

    # GET /categories/1
    # GET /categories/1.json
    def show; end

    # GET /categories/new
    def new
      @category = Category.new
      @category.parent_id = params[:parent_id]

      fetch_parents
    end

    # GET /categories/1/edit
    def edit
      fetch_parents(@category)
    end

    # POST /categories
    # POST /categories.json
    def create
      @category = Category.new(category_params)
      @category.client_id = current_client.id

      if @category.save
        redirect_to admin_category_path(@category), notice: _('The category was successfully created.')
      else
        fetch_parents

        render :new
      end
    end

    # PATCH/PUT /categories/1
    # PATCH/PUT /categories/1.json
    def update
      if @category.update(category_params)
        redirect_to admin_category_path(@category), notice: _('The category was successfully updated.')
      else
        fetch_parents(@category)

        render :edit
      end
    end

    # DELETE /categories/1
    # DELETE /categories/1.json
    def destroy
      @category.destroy

      redirect_to admin_categories_path, notice: _('The category was successfully deleted.')
    end

    # GET /categories/1/translate
    def translate; end

    # POST /categories/1/translate
    def save_translation
      @category.assign_attributes(translation_params)

      if @category.save_translation(translation_locale)
        redirect_to translate_admin_category_path(@category, translation_locale: translation_locale),
                    notice: _('The category was successfully translated.')
      else
        @translation.assign_attributes(translation_params)

        render :translate
      end
    end

    private

    def fetch_category
      @category = Category.find_by!(id: params[:id], client_id: current_client.id)
    end

    def fetch_translation
      @translation = @category.translate(translation_locale)
    end

    def fetch_templates
      path = Rails.root.join("app/views/templates/#{current_client.template}/categories/templates/*.html.erb")
      @templates = Dir[path].map { |f| File.basename(f, '.html.erb') }.sort
    end

    def fetch_parents(excluded_category = nil)
      @parents = Category.full_hierarchy(current_client.id, excluded_category).map do |id, hierarchy|
        [hierarchy.map(&:name).join(' > '), id]
      end.sort_by(&:first)
    end

    def category_params
      params.require(:category).permit(:image, :should_remove_image, :name, :slug, :description, :template, :parent_id)
    end

    def translation_params
      params.require(:category).permit(Category::TRANSLATABLE_FIELDS)
    end
  end
end