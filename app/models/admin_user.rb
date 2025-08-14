# frozen_string_literal: true

require 'uri'

# Admin user model
class AdminUser < ApplicationRecord
  SORTABLE_FIELDS = %i[username email].freeze
  TEXT_SEARCHABLE_FIELDS = %i[username email].freeze
  TRANSLATABLE_FIELDS = %w[first_name middle_name last_name description].freeze
  PASSWORD_LOWERCASE_CHARS = ('a'..'z').to_a.freeze
  PASSWORD_UPPERCASE_CHARS = ('A'..'Z').to_a.freeze
  PASSWORD_DIGITS = ('0'..'9').to_a.freeze
  PASSWORD_SYMBOLS = ['@', '#', '$', '!', '%', '*', '?', '&', '^'].freeze
  PASSWORD_REGEX = /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@\#$!%*?&^])[A-Za-z\d@\#$!%*?&^]{8,}\z/

  include SimpleTextSearchable
  include BoundSortable
  include Imageable
  include Translatable

  belongs_to :client, inverse_of: :admin_users

  has_many :admin_user_roles, inverse_of: :admin_user, dependent: :destroy
  has_many :pages, inverse_of: :author, foreign_key: :author_id, dependent: :destroy
  has_many :posts, inverse_of: :author, foreign_key: :author_id, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :confirmable, :lockable, :timeoutable,
         :trackable, :recoverable, :password_expirable, :password_archivable,
         :session_limitable

  enum :status, {
    active: 0,
    inactive: 1
  }

  attr_accessor :should_set_roles

  attribute :role, :string

  validates :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP },
                    length: { maximum: 255 },
                    uniqueness: { case_sensitive: false, scope: [:client_id] },
                    if: -> { email.present? && (new_record? || will_save_change_to_email?) }
  validates :username, presence: true
  validates :username, format: { with: /\A[A-Za-z0-9.-]*\z/ },
                       length: { maximum: 50 },
                       uniqueness: { case_sensitive: false, scope: [:client_id] },
                       if: -> { username.present? && (new_record? || will_save_change_to_username?) }
  validates :password, presence: true, if: -> { new_record? || password_confirmation.present? }
  validates :password, format: { with: PASSWORD_REGEX },
                       length: { maximum: 128 },
                       confirmation: { case_sensitive: false },
                       if: -> { password.present? }
  validates :first_name, length: { maximum: 255 }
  validates :middle_name, length: { maximum: 255 }
  validates :last_name, length: { maximum: 255 }

  after_save :set_roles, if: :should_set_roles

  def full_name
    "#{first_name} #{middle_name} #{last_name}".strip.squeeze(' ').presence || username
  end

  def supervisor?
    admin_user_roles.any?(&:supervisor?)
  end

  def supervisor!
    admin_user_roles.create!(role: :supervisor) unless supervisor?
  end

  def author?
    admin_user_roles.empty?
  end

  def author!
    admin_user_roles.destroy_all
  end

  def active_for_authentication?
    super && active?
  end

  def set_random_password
    password = nil

    loop do
      chars = [
        PASSWORD_LOWERCASE_CHARS.shuffle,
        PASSWORD_UPPERCASE_CHARS.shuffle,
        PASSWORD_DIGITS.shuffle,
        PASSWORD_SYMBOLS.shuffle
      ]

      password = Array.new(20) { chars.sample.sample }.join
      break if password.match?(PASSWORD_REGEX)
    end

    self.password = password
    self.password_confirmation = password
  end

  private

  def set_roles
    if role&.to_sym == :supervisor
      supervisor!
    else
      author!
    end
  end
end
