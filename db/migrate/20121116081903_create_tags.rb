# frozen_string_literal: true

class CreateTags < ActiveRecord::Migration[4.2]
  def self.up
    if table_exists?(:tags) == false
      create_table :tags do |t|
        t.column 'tagname', :string, null: false
      end
    end
  end

  def self.down
    drop_table :tags
  end
end
