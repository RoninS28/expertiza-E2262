# frozen_string_literal: true

class CreateTeamRolesets < ActiveRecord::Migration[4.2]
  def self.up
    create_table 'team_rolesets', force: true do |t|
      t.string 'roleset_name'
    end
  end

  def self.down
    drop_table :team_rolesets
  end
end
