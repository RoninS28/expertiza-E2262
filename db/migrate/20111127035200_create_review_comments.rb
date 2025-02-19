# frozen_string_literal: true

class CreateReviewComments < ActiveRecord::Migration[4.2]
  def self.up
    create_table :review_comments do |t|
      t.integer :review_file_id
      t.text :comment_content
      t.integer :reviewer_participant_id
      t.integer :file_offset

      t.timestamps
    end
  end

  def self.down
    drop_table :review_comments
  end
end
