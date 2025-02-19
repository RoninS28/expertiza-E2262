# frozen_string_literal: true

class UpdateControllerForExport < ActiveRecord::Migration[4.2]
  def self.up
    perm = Permission.find_by_name('administer assignments')
    controller = SiteController.find_or_create_by(name: 'export_file')
    controller.permission_id = perm.id
    controller.save

    Role.rebuild_cache
  end

  def self.down; end
end
