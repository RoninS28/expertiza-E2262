# frozen_string_literal: true

class RemoveSectionFromQuestionnaire < ActiveRecord::Migration[4.2]
  def change
    remove_column 'questionnaires', 'section'
  end
end
