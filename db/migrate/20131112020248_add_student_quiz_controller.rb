# frozen_string_literal: true

class AddStudentQuizController < ActiveRecord::Migration[4.2]
  def self.up
    permission = Permission.find_by_name('do assignments')
    controller = SiteController.where(name: 'student_quiz').first_or_create
    controller.permission_id = permission.id
    controller.save
  end

  def self.down; end
end
