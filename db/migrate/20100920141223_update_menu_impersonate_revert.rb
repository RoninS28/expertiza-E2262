# frozen_string_literal: true

class UpdateMenuImpersonateRevert < ActiveRecord::Migration[4.2]
  def self.up
    permission = Permission.find_by_name('do assignments')

    site_controller = SiteController.find_by_name('impersonate')
    action = ControllerAction.where('name = "restore" and site_controller_id = ?', site_controller.id).first
    action.name = 'impersonate'
    action.permission_id = permission.id
    action.save

    Role.rebuild_cache
  end

  def self.down; end
end
