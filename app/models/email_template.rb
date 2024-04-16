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

  def enabled?
    subject.present? && body.present?
  end

  def to_email(values)
    {
      subject: replace_params(subject, values),
      body: replace_params(body, values)
    }
  end

  private

  def replace_params(text, values)
    return text if text.blank?

    parameters.each_key { |key| text = text.gsub(key, values[key] || '') }
    text
  end
end
