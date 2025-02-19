# frozen_string_literal: true

class CreateBookmarkTags < ActiveRecord::Migration[4.2]
  def self.up
    create_table :bookmark_tags do |t|
      t.string :tag_name

      t.timestamps
    end
  end

  def self.down
    drop_table :bookmark_tags
  end
end
