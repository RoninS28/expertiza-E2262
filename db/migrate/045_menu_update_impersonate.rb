# frozen_string_literal: true

class MenuUpdateImpersonate < ActiveRecord::Migration[4.2]
  def self.up
    permission1 = Permission.find_by_name('administer assignments')
    permission2 = Permission.find_by_name('do assignments')
    site_controller = SiteController.find_by_name('impersonate')
    if site_controller.nil?
      site_controller = SiteController.create(name: 'impersonate', permission_id: permission1.id, builtin: 0)
    end
    action = ControllerAction.where(['name = "start" and site_controller_id = ?', site_controller.id]).first
    if action.nil?
      action = ControllerAction.create(name: 'start', site_controller_id: site_controller.id)
    end

    action2 = ControllerAction.where(['name = "restore" and site_controller_id = ?', site_controller.id]).first
    if action2.nil?
      action2 = ControllerAction.create(name: 'restore', site_controller_id: site_controller.id, permission_id: permission2.id)
    end

    parent = MenuItem.find_by_name('admin')
    MenuItem.create(name: 'impersonate', label: 'Impersonate User', parent_id: parent.id, seq: 6, controller_action_id: action.id)
    Role.rebuild_cache
  end

  def self.down
    site_controller = SiteController.find_by_name('impersonate')
    if site_controller
      controllers = ControllerAction.where(['site_controller_id = ?', site_controller.id])
      controllers.each do |controller|
        next unless controller

        menuItem = MenuItem.find_by_controller_action_id(controller.id)
        menuItem&.destroy
        controller.destroy
      end
      site_controller.destroy
    end
    Role.rebuild_cache
  end
end
