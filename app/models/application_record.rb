# frozen_string_literal: true

# Base application record
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
