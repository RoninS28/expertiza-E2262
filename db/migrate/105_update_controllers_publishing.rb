# frozen_string_literal: true

class UpdateControllersPublishing < ActiveRecord::Migration[4.2]
  def self.up
    perm = Permission.find_by_name('do assignments')

    controller = SiteController.find_or_create_by(name: 'publishing')
    controller.permission_id = perm.id
    controller.save

    Role.rebuild_cache
  end

  def self.down; end
end
