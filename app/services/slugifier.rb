# frozen_string_literal: true

class Slugifier < ApplicationService
  def initialize(str)
    super()
    @str = str
  end

  def call
    transliterate = :greek if /[\u0370-\u03FF\u1F00-\u1FFF]/.match?(@str)
    @str.to_slug.normalize(transliterate:).to_s
  end
end
