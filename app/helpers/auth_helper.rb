# frozen_string_literal: true

module AuthHelper
  def self.get_home_action(user)
    user.role.get_home_action
  rescue StandardError
    'drill'
  end

  def self.get_home_controller(user)
    user.role.get_home_controller
  rescue StandardError
    'tree_display'
  end
end
