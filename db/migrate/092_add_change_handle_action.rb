# frozen_string_literal: true

class AddChangeHandleAction < ActiveRecord::Migration[4.2]
  def self.up
    controller = SiteController.find_by_name('participants')
    permission = Permission.find_by_name('do assignments')

    ControllerAction.create(site_controller_id: controller.id,
                            name: 'change_handle',
                            permission_id: permission.id)

    Role.rebuild_cache
  end

  def self.down; end
end
