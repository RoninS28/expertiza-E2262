# frozen_string_literal: true

class PermissionForAddDynamicReviewerAction < ActiveRecord::Migration[4.2]
  def self.up
    controller_id = SiteController.find_by_name('review_mapping').id
    do_assignments_id = Permission.find_by_name('do assignments').id
    %w[add_dynamic_reviewer release_reservation].each do |action|
      ControllerAction.create site_controller_id: controller_id, name: action, permission_id: do_assignments_id, url_to_use: ''
    end
    Role.rebuild_cache
  end

  def self.down
    %w[add_dynamic_reviewer release_reservation].each do |action|
      ControllerAction.where(name: action).each &:destroy
    end
    Role.rebuild_cache
  end
end
