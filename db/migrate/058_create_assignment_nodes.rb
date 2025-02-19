# frozen_string_literal: true

class CreateAssignmentNodes < ActiveRecord::Migration[4.2]
  def self.up
    assignments = Assignment.all

    folder = TreeFolder.find_by_name('Assignments')
    parent = FolderNode.find_by_node_object_id(folder.id)

    assignments.each do |assignment|
      AssignmentNode.create(node_object_id: assignment.id, parent_id: parent.id)
    end
  end

  def self.down
    nodes = AssignmentNode.all
    nodes.each(&:destroy)
  end
end
