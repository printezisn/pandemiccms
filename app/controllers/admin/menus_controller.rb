# frozen_string_literal: true

module Admin
  # Admin menus controller
  class MenusController < BaseController
    PAGE_SIZE = 10

    before_action :fetch_menu, only: %i[show edit update destroy translate save_translation]
    before_action :fetch_translation, only: %i[translate save_translation]
    before_action :fetch_menu_items, only: :show

    # GET /menus
    # GET /menus.json
    def index
      @menus = Menu.where(client_id: current_client.id)
                   .simple_text_search(params[:search])
                   .bound_sort(params[:sort_by], params[:dir])
                   .page(params[:page].to_i)
                   .per(PAGE_SIZE)
      render :_menus_table, layout: nil if request.xhr?
    end

    # GET /menus/1
    # GET /menus/1.json
    def show; end

    # GET /menus/new
    def new
      @menu = Menu.new
    end

    # GET /menus/1/edit
    def edit; end

    # POST /menus
    # POST /menus.json
    def create
      @menu = Menu.new(menu_params)
      @menu.client_id = current_client.id

      if @menu.save
        CacheVersionBumper.call(current_client.id)
        redirect_to admin_menu_path(@menu), notice: _('The menu was successfully created.')
      else
        render :new
      end
    end

    # PATCH/PUT /menus/1
    # PATCH/PUT /menus/1.json
    def update
      if @menu.update(menu_params)
        CacheVersionBumper.call(current_client.id)
        redirect_to admin_menu_path(@menu), notice: _('The menu was successfully updated.')
      else
        render :edit
      end
    end

    # DELETE /menus/1
    # DELETE /menus/1.json
    def destroy
      @menu.destroy
      CacheVersionBumper.call(current_client.id)

      redirect_to admin_menus_path, notice: _('The menu was successfully deleted.')
    end

    # GET /menus/1/translate
    def translate; end

    # POST /menus/1/translate
    def save_translation
      @menu.assign_attributes(translation_params)

      if @menu.save_translation(translation_locale)
        CacheVersionBumper.call(current_client.id)
        redirect_to translate_admin_menu_path(@menu, translation_locale:),
                    notice: _('The menu was successfully translated.')
      else
        @translation.assign_attributes(translation_params)

        render :translate
      end
    end

    private

    def fetch_menu
      @menu = Menu.find_by!(id: params[:id], client_id: current_client.id)
    end

    def fetch_translation
      @translation = @menu.translate(translation_locale)
    end

    def fetch_menu_items
      @menu_items = MenuItem.ordered_by_hierarchy(@menu.menu_items.includes(:linkable), :sort_order)
    end

    def menu_params
      params.expect(menu: %i[name description])
    end

    def translation_params
      params.expect(menu: Menu::TRANSLATABLE_FIELDS)
    end
  end
end
