# frozen_string_literal: true

# Controller with seo-related actions
class SeoController < ApplicationController
  # /robots.txt
  def robots
    respond_to do |format|
      format.text
    end
  end

  # /sitemap.xml
  def sitemap
    respond_to do |format|
      format.xml
    end
  end
end
