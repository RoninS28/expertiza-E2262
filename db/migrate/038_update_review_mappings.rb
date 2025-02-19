# frozen_string_literal: true

class UpdateReviewMappings < ActiveRecord::Migration[4.2]
  def self.up
    add_column 'review_mappings', 'round', :integer

    execute 'update review_mappings set round = -1'
end

  def self.down
    remove_column 'review_mappings', 'round'
  end
end
