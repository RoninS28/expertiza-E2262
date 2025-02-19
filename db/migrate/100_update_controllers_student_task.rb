# frozen_string_literal: true

class UpdateControllersStudentTask < ActiveRecord::Migration[4.2]
  def self.up
    perm = Permission.find_by_name('do assignments')
    controller = SiteController.find_by_name('student_assignment')
    controller.name = 'student_task'
    controller.save

    item = MenuItem.find_by_name('student_assignment')
    item.name = 'student_task'
    item.save

    controller = SiteController.find_or_create_by(name: 'submitted_content')
    controller.permission_id = perm.id
    controller.save

    controller = SiteController.find_or_create_by(name: 'eula')
    controller.permission_id = perm.id
    controller.save

    controller = SiteController.find_or_create_by(name: 'student_review')
    controller.permission_id = perm.id
    controller.save

    Role.rebuild_cache
  end

  def self.down; end
end
