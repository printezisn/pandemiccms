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
           <loc>http://www.example.com#{page.decorate.path}</loc>
           <lastmod>#{page.reload.updated_at.iso8601}</lastmod>
         </url>
         <url>
           <loc>http://www.example.com#{category.decorate.path}</loc>
           <lastmod>#{category.reload.updated_at.iso8601}</lastmod>
         </url>
         <url>
           <loc>http://www.example.com#{post.decorate.path}</loc>
           <lastmod>#{post.reload.updated_at.iso8601}</lastmod>
         </url>
         <url>
           <loc>http://www.example.com#{tag.decorate.path}</loc>
           <lastmod>#{tag.reload.updated_at.iso8601}</lastmod>
         </url>
       </urlset>".gsub(/\s+/, '')
    end

    before { get sitemap_path }

    it { is_expected.to eq(expected_result) }
  end

  describe 'GET /robots.txt' do
    subject { response.body.gsub(/\s+/, '') }

    let(:expected_result) do
      "User-agent: *
       Disallow: /admin/
       Disallow: /queue/
       Disallow: /super_admin/
       Sitemap: http://www.example.com/sitemap.xml".gsub(/\s+/, '')
    end

    before do
      create(:client)

      get robots_path
    end

    it { is_expected.to eq(expected_result) }
  end
end
