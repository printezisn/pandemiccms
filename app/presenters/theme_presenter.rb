# frozen_string_literal: true

# Presenter with useful methods for themes
class ThemePresenter
  attr_reader :client_id, :locale, :admin_user

  def initialize(client_id, locale, admin_user)
    @client_id = client_id
    @locale = locale
    @admin_user = admin_user
  end

  def menu(name)
    @menu ||= {}
    @menu[name] ||= fetch_menu(name)
  end

  def posts(only_visible: true)
    query = Post.includes(:translations).where(client_id:)
    query = query.where(visibility: :public, status: :published) if admin_user.nil? && only_visible

    query
  end

  def pages(only_visible: true)
    query = Page.includes(:translations).where(client_id:)
    query = query.where(visibility: :public, status: :published) if admin_user.nil? && only_visible

    query
  end

  def categories(only_visible: true, post_id: nil)
    query = Category.includes(:translations).where(client_id:)
    query = query.where(visibility: :public) if admin_user.nil? && only_visible
    if post_id
      query = query.joins(:category_categorizables)
                   .where(category_categorizables: { categorizable_type: Post.name, categorizable_id: post_id })
    end

    query
  end

  def tags(only_visible: true, post_id: nil)
    query = Tag.includes(:translations).where(client_id:)
    query = query.where(visibility: :public) if admin_user.nil? && only_visible
    query = query.joins(:tag_taggables).where(tag_taggables: { taggable_type: Post.name, taggable_id: post_id }) if post_id

    query
  end

  def t(entity)
    return if entity.nil?

    @translation ||= {}
    @translation[entity.class.name] ||= {}
    @translation[entity.class.name][entity.id] ||= entity.translate(locale, use_defaults: true)
  end

  def search_posts(text, only_visible: true)
    repo = Elastic::PostRepository.new(client_id, locale)

    matching_post_ids = repo.search(
      query: {
        multi_match: {
          query: text.to_s,
          fuzziness: 'AUTO'
        }
      },
      size: 1000
    ).to_a.map { |post| post.attributes['id'] }

    posts(only_visible:).where(id: matching_post_ids)
  end

  private

  def fetch_menu(name)
    menu_items = MenuItem.includes(:translations, :linkable, linkable: :translations)
                         .joins(:menu)
                         .where(menus: { client_id:, name: })

    fetch_menu_item_children(menu_items, nil)
  end

  def fetch_menu_item_children(all_menu_items, parent_id)
    all_menu_items
      .select { |menu_item| menu_item.parent_id == parent_id }
      .sort_by(&:sort_order)
      .map { |menu_item| [menu_item.decorate, fetch_menu_item_children(all_menu_items, menu_item.id)] }
  end
end
