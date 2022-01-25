# frozen_string_literal: true

# Service class to fetch asset paths
class AssetPathFetcher < ApplicationService
  attr_reader :name, :extension

  def initialize(name, extension)
    super()

    @name = name
    @extension = extension
  end

  def call
    @@asset_paths ||= {}
    key = "#{name}#{extension}"

    return @@asset_paths[key] if @@asset_paths[key]

    dirpath = name.include?('/') ? Rails.root.join("public/assets/#{File.dirname(name)}").to_s : Rails.root.join('public/assets').to_s
    fingerprinted_filename = Dir.entries(dirpath).detect do |filename|
      filename.start_with?("#{File.basename(name)}-") && filename.end_with?(extension)
    end
    asset_path = name.include?('/') ? "/assets/#{File.dirname(name)}/#{fingerprinted_filename}" : "/assets/#{fingerprinted_filename}"

    return asset_path if Rails.env.development?

    @@asset_paths[key] = asset_path
  end
end
