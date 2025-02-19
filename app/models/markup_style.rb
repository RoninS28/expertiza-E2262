# frozen_string_literal: true

class MarkupStyle < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true
  # attr_accessible :name
end
