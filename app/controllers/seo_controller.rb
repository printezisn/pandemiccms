# frozen_string_literal: true

# Controller with seo-related actions
class SeoController < ApplicationController
  def sitemap
    respond_to do |format|
      format.xml
    end
  end
end
