# frozen_string_literal: true

class UpdateReviewFeedbacks < ActiveRecord::Migration[4.2]
  def self.up
    rename_column :review_feedbacks, :user_id, :author_id
    rename_column :review_feedbacks, :txt, :additional_comment
  end

  def self.down
    rename_column :review_feedbacks, :author_id, :user_id
    rename_column :review_feedbacks, :additional_comment, :txt
  end
end
