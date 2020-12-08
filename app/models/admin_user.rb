# frozen_string_literal: true

require 'uri'
require_relative './validators/email_validator'

# Admin user model
class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :confirmable, :lockable, :timeoutable,
         :trackable, :recoverable, :password_expirable, :password_archivable,
         :session_limitable

  validates :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP },
                    length: { maximum: 255 },
                    uniqueness: { case_sensitive: false, scope: [:client_id] },
                    if: -> { email.present? }
  validates :username, presence: true
  validates :username, format: { with: /\A[A-Za-z0-9.\-]*\z/ },
                       length: { maximum: 50 },
                       uniqueness: { case_sensitive: false, scope: [:client_id] },
                       if: -> { username.present? }
  validates :password, presence: true, if: -> { new_record? || password_confirmation.present? }
  validates :password, format: { with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}\z/ },
                       length: { maximum: 128 },
                       confirmation: { case_sensitive: false },
                       if: -> { password.present? }
end
