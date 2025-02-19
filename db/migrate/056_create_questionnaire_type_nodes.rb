# frozen_string_literal: true

class CreateQuestionnaireTypeNodes < ActiveRecord::Migration[4.2]
  def self.up
    # Retrieve all questionnaire types
    types = ActiveRecord::Base.connection.select_all('select * from questionnaire_types')
    folder = TreeFolder.find_by_name('Questionnaires')
    parent = FolderNode.find_by_node_object_id(folder.id)
    types.each  do |type|
      QuestionnaireTypeNode.create(node_object_id: type['id'], parent_id: parent.id)
    end
  end

  def self.down
    nodes = QuestionnaireTypeNode.all
    nodes.each(&:destroy)
  end
end
