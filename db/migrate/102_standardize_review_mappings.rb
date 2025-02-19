# frozen_string_literal: true

class StandardizeReviewMappings < ActiveRecord::Migration[4.2]
  def self.up
    begin
      execute "ALTER TABLE `review_mappings`
               DROP FOREIGN KEY `fk_review_mapping_assignments`"
    rescue StandardError
    end

    begin
      execute "ALTER TABLE `review_mappings`
               DROP INDEX `fk_review_mapping_assignments`"
    rescue StandardError
    end

    begin
      execute "ALTER TABLE `review_mappings`
               DROP FOREIGN KEY `fk_review_users_reviewer`"
    rescue StandardError
    end

    begin
      execute "ALTER TABLE `review_mappings`
               DROP INDEX `fk_review_users_reviewer`"
    rescue StandardError
    end

    begin
      execute "ALTER TABLE `review_mappings`
               DROP FOREIGN KEY `fk_review_users_author`"
    rescue StandardError
    end

    begin
      execute "ALTER TABLE `review_mappings`
               DROP INDEX `fk_review_users_author`"
    rescue StandardError
    end

    begin
      execute "ALTER TABLE `review_mappings`
               DROP FOREIGN KEY `fk_review_teams`"
    rescue StandardError
    end

    begin
      execute "ALTER TABLE `review_mappings`
               DROP INDEX `fk_review_teams`"
    rescue StandardError
    end

    rename_column :review_mappings, :reviewer_id, :old_reviewer_id
    add_column :review_mappings, :reviewer_id, :integer, null: false
    add_column :review_mappings, :reviewee_id, :integer, null: false
    rename_column :review_mappings, :assignment_id, :reviewed_object_id
    remove_column :review_mappings, :round
    add_column :review_mappings, :type, :string, null: false

    records = ActiveRecord::Base.connection.select_all('select * from `review_mappings`')

    records.each do |mapping|
      begin
        update_mapping(mapping)
      rescue StandardError
        delete(mapping, $ERROR_INFO)
      end
    end

    remove_column :review_mappings, :author_id
    remove_column :review_mappings, :team_id
    remove_column :review_mappings, :old_reviewer_id

    execute "ALTER TABLE `review_mappings`
             ADD CONSTRAINT `fk_review_mappings_participant_reviewers`
             FOREIGN KEY (reviewer_id) references participants(id)"

    execute "ALTER TABLE `review_mappings`
             ADD CONSTRAINT `fk_review_mappings_assignments`
             FOREIGN KEY (reviewed_object_id) references assignments(id)"

    execute "ALTER TABLE `reviews`
             ADD CONSTRAINT `fk_review_review_mapping`
             FOREIGN KEY (mapping_id) references review_mappings(id)"
  end

  def self.update_mapping(mapping)
    today = Time.now
    oldest_allowed_time = Time.local(today.year - 1, today.month, today.day, 0, 0, 0)
    assignment = Assignment.find(mapping['reviewed_object_id'])
    review = ActiveRecord::Base.connection.select_one("select * from `reviews` where id = #{mapping['id']}")

    if assignment.nil?
      raise "DELETE ReviewMapping #{mapping['id']}: No assignment found with ID = #{mapping['reviewed_object_id']}"
    elsif review.nil? && (assignment.created_at.nil? || (assignment.created_at < oldest_allowed_time))
      raise "DELETE ReviewMapping #{mapping['id']}: This mapping is at least a year old and has no review associated with it."
    else
      if mapping['old_reviewer_id'] == 0
        raise "DELETE ReviewMapping #{mapping['id']}: Invalid reviewer ID"
      end

      reviewer = get_participant_reviewer(mapping)

      if reviewer.nil?
        raise "DELETE ReviewMapping #{mapping['id']}: The reviewer does not exist as a participant: assignment_id: #{assignment.id}, user_id #{mapping['old_reviewer_id']}"
      end

      if assignment.team_assignment
        type = 'TeamReviewMapping'
        reviewee = get_team_reviewee(mapping)
      else
        type = 'ParticipantReviewMapping'
        reviewee = get_participant_reviewee(mapping)
      end

      if reviewee.nil?
        raise "DELETE ReviewMapping #{mapping['id']}: The reviewee does not exist as a participant: assignment_id: #{assignment.id}, user_id #{mapping['author_id']} or team_id: #{mapping['team_id']}"
      end

      execute "Update `review_mappings` set reviewee_id = #{reviewee.id}, reviewer_id = #{reviewer.id}, type = #{type} where id = #{mapping['id']}"

    end
  end

  def self.delete(mapping, _reason)
    execute "delete from `review_mappings` where id = #{mapping['id']}"
    mapping.delete(true)
  rescue StandardError
  end

  # return the participant acting as reviewer for this mapping
  def self.get_participant_reviewer(mapping)
    make_participant(mapping['old_reviewer_id'], mapping['reviewed_object_id'])
  end

  # return the participant acting as reviewee for this mapping
  def self.get_participant_reviewee(mapping)
    make_participant(mapping['author_id'], mapping['reviewed_object_id'])
  end

  # return the team acting as reviewee for this mapping
  def self.get_team_reviewee(mapping)
    if !mapping['team_id'].nil?
      begin
        reviewee = AssignmentTeam.find(mapping['team_id'])
      rescue StandardError
      end
    elsif !mapping['author_id'].nil?
      participant = make_participant(mapping['author_id'], mapping['reviewed_object_id'])
      reviewee = participant.team
    else
      mapping.destroy
    end

    reviewee = create_team(mapping) if reviewee.nil?
    reviewee
  end

  # create a participant based on a user and assignment
  def self.make_participant(user_id, assignment_id)
    participant = nil
    if user_id.to_i > 0
      user = User.find(user_id)
      if user
        participant = AssignmentParticipant.where(user_id: user_id, parent_id: assignment_id).first

        if participant.nil?
          participant = AssignmentParticipant.create(user_id: user_id, parent_id: assignment_id)
          participant.set_handle
        end
      end
    end
    participant
  end

  # if a team does not already exist to act as a reviewee, create it based on the author id provided
  def self.create_team(mapping)
    # if the author is not available, no team can be made
    return nil if (mapping['author_id'] == 0) || mapping['author_id'].nil?

    # create a participant for this user, all users have to be a participant in order to interact with an assignment
    user = User.find(mapping['author_id'])
    if AssignmentParticipant.where(user_id: mapping['author_id'], parent_id: mapping['reviewed_object_id']).first.nil?
      make_participant(mapping['author_id'], mapping['reviewed_object_id'])
    end

    # if the user was found, create a team based on the user
    unless user.nil?
      team = AssignmentTeam.create(name: 'Team' + mapping['author_id'].to_s, parent_id: mapping['reviewed_object_id'])
      TeamsUser.create(team_id: team.id, user_id: mapping['author_id'])
    end
    team
  end

  def self.down; end
end
