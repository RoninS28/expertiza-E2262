# frozen_string_literal: true

class SetPermissionForSuggestion < ActiveRecord::Migration[4.2]
  def self.up
    permission = Permission.find_by_name('administer assignments')
    controller = SiteController.find_or_create_by(name: 'suggestion')
    controller.permission_id = permission.id
    controller.save

    permission = Permission.find_by_name('do assignments')
    action = ControllerAction.find_or_create_by(name: 'new')
    action.site_controller_id = controller.id
    action.permission_id = permission.id
    action.save

    action = ControllerAction.find_or_create_by(name: 'create')
    action.site_controller_id = controller.id
    action.permission_id = permission.id
    action.save

    Role.rebuild_cache
  end

  def self.down; end
end
