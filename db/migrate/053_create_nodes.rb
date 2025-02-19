# frozen_string_literal: true

class CreateNodes < ActiveRecord::Migration[4.2]
  def self.up
    create_table :nodes do |t|
      t.column :parent_id, :integer
      t.column :node_object_id, :integer
      t.column :type, :string
    end
  end

  def self.down
    drop_table :nodes
  end
end
