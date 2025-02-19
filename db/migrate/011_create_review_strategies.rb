# frozen_string_literal: true

class CreateReviewStrategies < ActiveRecord::Migration[4.2]
  def self.up
    create_table 'review_strategies', force: true do |t|
      t.column 'name', :string
    end

    execute "INSERT INTO `review_strategies` VALUES (1,'questionnaire');"
  end

  def self.down
    drop_table 'review_strategies'
  end
end
