# frozen_string_literal: true

class UpdateSiteControllersForVersions < ActiveRecord::Migration[4.2]
  def self.up
    @permission = Permission.find_by_name('public actions - execute')
    @controller = SiteController.find_or_create_by(name: 'versions')
    @controller.permission_id = @permission.id
    @controller.save

    Role.rebuild_cache
  end

  def self.down; end
end
