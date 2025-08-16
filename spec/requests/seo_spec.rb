# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'seo' do
  describe 'GET /sitemap.xml' do
    subject { response.body.gsub(/\s+/, '') }

    let!(:post) { create(:post, name: 'Test Post', slug: 'test-post', status: :published) }
    let!(:page) { create(:page, name: 'Test Page', slug: 'test-page', status: :published) }
    let!(:category) { create(:category, name: 'Test Category', slug: 'test-category') }
    let!(:tag) { create(:tag, name: 'Test Tag', slug: 'test-tag') }

    let(:expected_result) do
      "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
       <urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\" xmlns:xhtml=\"http://www.w3.org/1999/xhtml\">
         <url>
           <loc>http://www.example.com#{sample_page_path(id: page.id, slug: page.slug, locale: nil)}</loc>
           <lastmod>#{page.reload.updated_at.iso8601}</lastmod>
         </url>
         <url>
           <loc>http://www.example.com#{sample_category_path(id: category.id, slug: category.slug, locale: nil)}</loc>
           <lastmod>#{category.reload.updated_at.iso8601}</lastmod>
         </url>
         <url>
           <loc>http://www.example.com#{sample_post_path(id: post.id, slug: post.slug, locale: nil)}</loc>
           <lastmod>#{post.reload.updated_at.iso8601}</lastmod>
         </url>
         <url>
           <loc>http://www.example.com#{sample_tag_path(id: tag.id, slug: tag.slug, locale: nil)}</loc>
           <lastmod>#{tag.reload.updated_at.iso8601}</lastmod>
         </url>
       </urlset>".gsub(/\s+/, '')
    end

    before { get sample_sitemap_path }

    it { is_expected.to eq(expected_result) }
  end

  describe 'GET /robots.txt' do
    subject { response.body.gsub(/\s+/, '') }

    let(:expected_result) do
      "User-agent: *
       Disallow: /admin/
       Disallow: /jobs/
       Disallow: /super_admin/
       Sitemap: http://www.example.com/sitemap.xml".gsub(/\s+/, '')
    end

    before do
      create(:client)

      get sample_robots_path
    end

    it { is_expected.to eq(expected_result) }
  end

  describe 'GET /manifest.webmanifest' do
    subject { response.body.gsub(/\s+/, '') }

    let(:expected_result) do
      '{
          "theme_color": "#404654",
          "background_color": "#f9fafb",
          "display": "standalone",
          "scope": "/",
          "start_url": "/",
          "name": "test_client",
          "short_name": "test_client",
          "description": "",
          "icons": [
              {
                "src": "/logo.png",
                "sizes": "192x192",
                "type": "image/png"
              }
              {
                "src": "/logo.png",
                "sizes": "256x256",
                "type": "image/png"
              }
              {
                "src": "/logo.png",
                "sizes": "384x384",
                "type": "image/png"
              }
              {
                "src": "/logo.png",
                "sizes": "512x512",
                "type": "image/png"
              }
          ]
        }'.gsub(/\s+/, '')
    end

    before do
      create(:client)

      get sample_manifest_path
    end

    it { is_expected.to eq(expected_result) }
  end
end
