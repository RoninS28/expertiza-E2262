# frozen_string_literal: true

class CreateBids < ActiveRecord::Migration[4.2]
  def self.up
    create_table :bids do |t|
      t.belongs_to :topic
      t.belongs_to :team
      t.timestamps
    end
  end

  def self.down
    drop_table :bids
  end
end
