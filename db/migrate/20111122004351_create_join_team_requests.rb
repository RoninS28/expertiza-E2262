# frozen_string_literal: true

class CreateJoinTeamRequests < ActiveRecord::Migration[4.2]
  def self.up
    create_table :join_team_requests do |t|
      t.column :participant_id, :integer
      t.column :team_id, :integer
      t.column :comments, :text
      t.column :status, :char
      t.timestamps
    end
  end

  def self.down
    drop_table :join_team_requests
  end
end
