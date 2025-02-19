# frozen_string_literal: true

class UpdateMenuDeleteObject < ActiveRecord::Migration[4.2]
  def self.up
    permission = Permission.find_by_name('administer assignments')

    site_controller = SiteController.create(name: 'delete_object', permission_id: permission.id)

    Role.rebuild_cache
  end

  def self.down; end
end
