# frozen_string_literal: true

class DropTableTeamRoles < ActiveRecord::Migration[4.2]
  def change
    drop_table :team_roles
  end
end
