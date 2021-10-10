# frozen_string_literal: true

client_cache 'Sitemap' do
  xml.instruct! :xml, version: '1.0'
  xml.tag! 'urlset', 'xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9', 'xmlns:xhtml' => 'http://www.w3.org/1999/xhtml' do
    @tp.pages.find_each do |page|
      next if %w[internal_error not_found].include?(page.template)

      xml << (render partial: 'seo/sitemap_entity', locals: { entity: page })
    end
    @tp.categories.find_each { |category| xml << (render partial: 'seo/sitemap_entity', locals: { entity: category }) }
    @tp.posts.find_each { |post| xml << (render partial: 'seo/sitemap_entity', locals: { entity: post }) }
    @tp.tags.find_each { |tag| xml << (render partial: 'seo/sitemap_entity', locals: { entity: tag }) }
  end
end
