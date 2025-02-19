# frozen_string_literal: true

class AlterAssignments < ActiveRecord::Migration[4.2]
  def self.up
    add_column 'assignments', 'selfreview_questionnaire_id', :integer
    add_column 'assignments', 'managerreview_questionnaire_id', :integer
    add_column 'assignments', 'readerreview_questionnaire_id', :integer
  end

  def self.down
    remove_column 'assignments', 'selfreview_questionnaire_id'
    remove_column 'assignments', 'managerreview_questionnaire_id'
    remove_column 'assignments', 'readerreview_questionnaire_id'
  end
end
