# frozen_string_literal: true

class RemoveQuizQuestionTypeFromQuestionnaires < ActiveRecord::Migration[4.2]
  def self.up
    remove_column :questionnaires, :quiz_question_type
  end

  def self.down
    add_column :questionnaires, :quiz_question_type, :text
  end
end
