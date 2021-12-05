# frozen_string_literal: true

module ThemeInitializer
  # Initializer for the sample theme
  class Sample < ApplicationService
    def initialize(client, admin_user)
      super()

      @client = client
      @admin_user = admin_user
    end

    def call
      home_page = Page.create!(name: 'Home Page', template: 'index', client_id: client.id, author_id: admin_user.id,
                               status: :published, published_at: Time.now.utc)
      Page.create!(name: 'Search', template: 'search', client_id: client.id, author_id: admin_user.id,
                   parent_id: home_page.id, status: :published, published_at: Time.now.utc)
      Page.create!(name: 'Page not found', template: 'not_found', client_id: client.id, author_id: admin_user.id,
                   parent_id: home_page.id, body: 'The page you requested was not found.', status: :published, published_at: Time.now.utc)
      Page.create!(name: 'An error occurred', template: 'internal_error', client_id: client.id, author_id: admin_user.id,
                   parent_id: home_page.id, body: 'An unexpected error occurred. Please try again later.',
                   status: :published, published_at: Time.now.utc)

      hero_category = Category.create!(name: 'Hero', template: 'default', visibility: :private, client_id: client.id)

      Post.create!(name: client.name, categories: [hero_category], template: 'default', visibility: :private,
                   client_id: client.id, author_id: admin_user.id, body: 'Insert subtitle', status: :published,
                   published_at: Time.now.utc)
      Post.create!(name: 'Footer', template: 'default', visibility: :private, client_id: client.id, author_id: admin_user.id,
                   body: 'Insert footer text', status: :published, published_at: Time.now.utc)
      Post.create!(name: 'My first post', template: 'without_author', client_id: client.id, author_id: admin_user.id,
                   body: 'This is my first post.', status: :published, published_at: Time.now.utc)

      header_menu = Menu.create!(name: 'Header Menu', client_id: client.id)
      header_menu.menu_items.create!(name: 'Home', linkable: home_page)

      footer_menu = Menu.create!(name: 'Footer Menu', client_id: client.id)
      footer_menu.menu_items.create!(name: 'Home', linkable: home_page)

      [
        EmailTemplateType::AccountConfirmation,
        EmailTemplateType::EmailChange,
        EmailTemplateType::PasswordChange,
        EmailTemplateType::ResetPasswordInstructions
      ].each { |email_template_type| email_template_type.create!(client_id: client.id) }
    end

    private

    attr_reader :client, :admin_user
  end
end
