# frozen_string_literal: true

# Controller with seo-related actions
class SeoController < ApplicationController
  # /robots.txt
  def robots
    respond_to do |format|
      format.text { render template: "templates/#{current_client.template}/seo/robots" }
    end
  end

  # /sitemap.xml
  def sitemap
    respond_to do |format|
      format.xml { render template: "templates/#{current_client.template}/seo/sitemap" }
    end
  end

  # /sitemap.webmanifest
  def manifest
    respond_to do |format|
      format.json { render template: "templates/#{current_client.template}/seo/manifest" }
    end
  end
end
