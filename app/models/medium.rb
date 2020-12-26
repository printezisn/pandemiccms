# frozen_string_literal: true

# Medium model
class Medium < ApplicationRecord
  has_one_attached :file

  validates :client_id, presence: true
  validate :file_presence

  before_save :set_name, if: -> { file.attached? }

  private

  def set_name
    self.name = file.filename
  end

  def file_presence
    return if file.attached?

    errors.add(:file, :blank)
  end
end
