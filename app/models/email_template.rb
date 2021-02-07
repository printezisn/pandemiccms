# frozen_string_literal: true

# Email template model
class EmailTemplate < ApplicationRecord
  TRANSLATABLE_FIELDS = %w[subject body].freeze

  include Translatable

  belongs_to :client, inverse_of: :email_templates

  validates :subject, presence: true,
                      length: { maximum: 255 },
                      if: -> { body.present? }
  validates :body, presence: true, if: -> { subject.present? }
end
