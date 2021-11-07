# frozen_string_literal: true

module Admin
  # Admin menu items controller
  class MenuItemsController < BaseController
    LINKABLE_TYPES = %w[Page Post Category Tag].freeze

    before_action :fetch_menu
    before_action :fetch_menu_item, only: %i[show edit update destroy translate save_translation]
    before_action :fetch_linkable, only: %i[create update]
    before_action :fetch_parents, only: %i[new create edit update]
    before_action :fetch_translation, only: %i[translate save_translation]

    # GET /menus/1/menu_items/1
    # GET /menus/1/menu_items/1.json
    def show; end

    # GET /menus/1/menu_items/new
    def new
      @menu_item = MenuItem.new
      @menu_item.parent_id = params[:parent_id]

      max_sort_order = @menu.menu_items.where(parent_id: @menu_item.parent_id).pluck(:sort_order).max || 0
      @menu_item.sort_order = max_sort_order + 1
    end

    # GET /menus/1/edit
    def edit; end

    # POST /menus/1/menu_items
    # POST /menus/1/menu_items.json
    def create
      @menu_item = MenuItem.new(menu_item_params)
      @menu_item.menu_id = @menu.id
      @menu_item.linkable = @linkable

      if @menu_item.save
        CacheVersionBumper.call(current_client.id)
        redirect_to admin_menu_menu_item_path(id: @menu_item.id, menu_id: @menu_item.menu_id),
                    notice: _('The menu item was successfully created.')
      else
        render :new
      end
    end

    # PATCH/PUT /menus/1/menu_items/1
    # PATCH/PUT /menus/1/menu_items/1.json
    def update
      @menu_item.assign_attributes(menu_item_params)
      @menu_item.linkable = @linkable

      if @menu_item.save
        CacheVersionBumper.call(current_client.id)
        redirect_to admin_menu_menu_item_path(id: @menu_item.id, menu_id: @menu_item.menu_id),
                    notice: _('The menu item was successfully updated.')
      else
        render :edit
      end
    end

    # DELETE /menus/1/menu_items/1
    # DELETE /menus/1/menu_items/1.json
    def destroy
      @menu_item.destroy
      CacheVersionBumper.call(current_client.id)

      redirect_to admin_menu_path(id: @menu_item.menu_id), notice: _('The menu item was successfully deleted.')
    end

    # GET /menus/1//menu_items/1/translate
    def translate; end

    # POST /menus/1/menu_items/1/translate
    def save_translation
      @menu_item.assign_attributes(translation_params)

      if @menu_item.save_translation(translation_locale)
        CacheVersionBumper.call(current_client.id)
        redirect_to translate_admin_menu_menu_item_path(id: @menu_item.id, menu_id: @menu_item.menu_id, translation_locale: translation_locale),
                    notice: _('The menu item was successfully translated.')
      else
        @translation.assign_attributes(translation_params)

        render :translate
      end
    end

    private

    def fetch_menu
      @menu = Menu.find_by!(id: params[:menu_id], client_id: current_client.id)
    end

    def fetch_menu_item
      @menu_item = @menu.menu_items.find(params[:id])
    end

    def fetch_linkable
      return if LINKABLE_TYPES.exclude?(linkable_params[:linkable_type]) || linkable_params[:linkable_id].blank?

      @linkable = linkable_params[:linkable_type]&.constantize&.find(linkable_params[:linkable_id])
    end

    def fetch_parents
      menu_items = @menu.menu_items.to_a
      menu_items.reject! { |menu_item| menu_item.id == @menu_item.id || menu_item.ancestor_ids.include?(@menu_item.id) } if @menu_item

      @parents = menu_items.map { |menu_item| [menu_item.name, menu_item.id] }
    end

    def fetch_translation
      @translation = @menu_item.translate(translation_locale)
    end

    def menu_item_params
      params.require(:menu_item).permit(:name, :external_url, :parent_id, :sort_order, :css_class, :open_in_new_window)
    end

    def linkable_params
      params.require(:menu_item).permit(:linkable_id, :linkable_type)
    end

    def translation_params
      params.require(:menu_item).permit(MenuItem::TRANSLATABLE_FIELDS)
    end
  end
end
