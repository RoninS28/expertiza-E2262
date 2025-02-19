# frozen_string_literal: true

class RenameDropTopic < ActiveRecord::Migration[4.2]
  def self.up
    drop_topic = DeadlineType.find_by_name('drop topic')
    drop_topic.name = 'drop_topic'
    drop_topic.save
  end

  def self.down
    drop_topic = DeadlineType.find_by_name('drop_topic')
    drop_topic.name = 'drop topic'
    drop_topic.save
  end
end
