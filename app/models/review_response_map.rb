# frozen_string_literal: true

class ReviewResponseMap < ResponseMap
  belongs_to :reviewee, class_name: 'Team', foreign_key: 'reviewee_id', inverse_of: false
  belongs_to :contributor, class_name: 'Team', foreign_key: 'reviewee_id', inverse_of: false
  belongs_to :assignment, class_name: 'Assignment', foreign_key: 'reviewed_object_id', inverse_of: false

  # Added for E1973:
  # http://wiki.expertiza.ncsu.edu/index.php/CSC/ECE_517_Fall_2019_-_Project_E1973._Team_Based_Reviewing
  # ReviewResponseMap was created in so many places, I thought it best to add this here as a catch-all
  def after_initialize
    # If an assignment supports team reviews, it is marked in each mapping
    assignment.team_reviewing_enabled
  end

  # Find a review questionnaire associated with this review response map's assignment
  def questionnaire(round_number = nil, topic_id = nil)
    Questionnaire.find(assignment.review_questionnaire_id(round_number, topic_id))
  end

  def get_title
    'Review'
  end

  def delete(_force = nil)
    fmaps = FeedbackResponseMap.where(reviewed_object_id: response.response_id)
    fmaps.each(&:destroy)
    maps = MetareviewResponseMap.where(reviewed_object_id: id)
    maps.each(&:destroy)
    destroy
  end

  def self.export_fields(_options)
    ['contributor', 'reviewed by']
  end

  def self.export(csv, parent_id, _options)
    mappings = where(reviewed_object_id: parent_id).to_a
    mappings.sort! { |a, b| a.reviewee.name <=> b.reviewee.name }
    mappings.each do |map|
      csv << [
        map.reviewee.name,
        map.reviewer.name
      ]
    end
  end

  def self.import(row_hash, _session, assignment_id)
    reviewee_user_name = row_hash[:reviewee].to_s
    reviewee_user = User.find_by(name: reviewee_user_name)
    raise ArgumentError, 'Cannot find reviewee user.' unless reviewee_user

    reviewee_participant = AssignmentParticipant.find_by(user_id: reviewee_user.id, parent_id: assignment_id)
    unless reviewee_participant
      raise ArgumentError, 'Reviewee user is not a participant in this assignment.'
    end

    reviewee_team = AssignmentTeam.team(reviewee_participant)
    if reviewee_team.nil? # lazy team creation: if the reviewee does not have team, create one.
      reviewee_team = AssignmentTeam.create(name: 'Team' + '_' + rand(1000).to_s,
                                            parent_id: assignment_id, type: 'AssignmentTeam')
      t_user = TeamsUser.create(team_id: reviewee_team.id, user_id: reviewee_user.id)
      team_node = TeamNode.create(parent_id: assignment_id, node_object_id: reviewee_team.id)
      TeamUserNode.create(parent_id: team_node.id, node_object_id: t_user.id)
    end
    row_hash[:reviewers].each do |reviewer|
      reviewer_user_name = reviewer.to_s
      reviewer_user = User.find_by(name: reviewer_user_name)
      raise ArgumentError, 'Cannot find reviewer user.' unless reviewer_user
      next if reviewer_user_name.empty?

      reviewer_participant = AssignmentParticipant.find_by(user_id: reviewer_user.id, parent_id: assignment_id)
      unless reviewer_participant
        raise ArgumentError, 'Reviewer user is not a participant in this assignment.'
      end

      ReviewResponseMap.find_or_create_by(reviewed_object_id: assignment_id,
                                          reviewer_id: reviewer_participant.get_reviewer.id,
                                          reviewee_id: reviewee_team.id,
                                          calibrate_to: false)
    end
  end

  def show_feedback(response)
    return unless self.response.any? && response

    map = FeedbackResponseMap.find_by(reviewed_object_id: response.id)
    map.response.last.display_as_html if map&.response&.any?
  end

  def metareview_response_maps
    responses = Response.where(map_id: id)
    metareview_list = []
    responses.each do |response|
      metareview_response_maps = MetareviewResponseMap.where(reviewed_object_id: response.id)
      metareview_response_maps.each { |metareview_response_map| metareview_list << metareview_response_map }
    end
    metareview_list
  end

  # return the responses for specified round, for varying rubric feature -Yang
  def self.get_responses_for_team_round(team, round)
    responses = []
    if team.id
      maps = ResponseMap.where(reviewee_id: team.id, type: 'ReviewResponseMap')
      maps.each do |map|
        if map.response.any? && map.response.reject { |r| (r.round != round || !r.is_submitted) }.any?
          responses << map.response.reject { |r| (r.round != round || !r.is_submitted) }.last
        end
      end
      responses.sort! { |a, b| a.map.reviewer.fullname <=> b.map.reviewer.fullname }
    end
    responses
  end

  # E-1973 - returns the reviewer of the response, either a participant or a team
  def get_reviewer
    ReviewResponseMap.get_reviewer_with_id(assignment.id, reviewer_id)
  end

  # E-1973 - gets the reviewer of the response, given the assignment and the reviewer id
  # the assignment is used to determine if the reviewer is a participant or a team
  def self.get_reviewer_with_id(assignment_id, reviewer_id)
    assignment = Assignment.find(assignment_id)
    if assignment.team_reviewing_enabled
      AssignmentTeam.find(reviewer_id)
    else
      AssignmentParticipant.find(reviewer_id)
    end
  end

  # wrap latest version of responses in each response map, together with the questionnaire_id
  # will be used to display the reviewer summary
  def self.final_versions_from_reviewer(assignment_id, reviewer_id)
    reviewer = ReviewResponseMap.get_reviewer_with_id(assignment_id, reviewer_id)
    maps = ReviewResponseMap.where(reviewer_id: reviewer_id)
    assignment = Assignment.find(reviewer.parent_id)
    prepare_final_review_versions(assignment, maps)
  end

  def self.review_response_report(id, assignment, type, review_user)
    if review_user.nil?
      # This is not a search, so find all reviewers for this assignment
      response_maps_with_distinct_participant_id =
        ResponseMap.select('DISTINCT reviewer_id').where('reviewed_object_id = ? and type = ? and calibrate_to = ?', id, type, 0)
      @reviewers = []
      response_maps_with_distinct_participant_id.each do |reviewer_id_from_response_map|
        @reviewers << ReviewResponseMap.get_reviewer_with_id(assignment.id, reviewer_id_from_response_map.reviewer_id)
      end
      # we sort the reviewer by name here, using whichever class it is an instance of
      @reviewers = if assignment.team_reviewing_enabled
                     Team.sort_by_name(@reviewers)
                   else
                     Participant.sort_by_name(@reviewers)
                   end
    else
      # This is a search, so find reviewers by user's full name
      user_ids = User.select('DISTINCT id').where('fullname LIKE ?', '%' + review_user[:fullname] + '%')
      # E1973 - we use a separate query depending on if the reviewer is a team or participant
      if assignment.team_reviewing_enabled
        reviewer_participants = AssignmentTeam.where('id IN (?) and parent_id = ?', team_ids, assignment.id)
        @reviewers = []
        reviewer_participants.each do |participant|
          unless @reviewers.include? participant.team
            @reviewers << participant.team
          end
        end
      else
        @reviewers = AssignmentParticipant.where('user_id IN (?) and parent_id = ?', user_ids, assignment.id)
      end
    end
    # @review_scores[reviewer_id][reviewee_id] = score for assignments not using vary_rubric_by_rounds feature
    # @review_scores[reviewer_id][round][reviewee_id] = score for assignments using vary_rubric_by_rounds feature
  end

  def email(defn, _participant, assignment)
    defn[:body][:type] = 'Peer Review'
    AssignmentTeam.find(reviewee_id).users.each do |user|
      defn[:body][:obj_name] = assignment.name
      defn[:body][:first_name] = User.find(user.id).fullname
      defn[:to] = User.find(user.id).email
      Mailer.sync_message(defn).deliver_now
    end
  end

  def self.prepare_final_review_versions(assignment, maps)
    review_final_versions = {}
    rounds_num = assignment.rounds_of_reviews
    if rounds_num && (rounds_num > 1)
      (1..rounds_num).each do |round|
        prepare_review_response(assignment, maps, review_final_versions, round)
      end
    else
      prepare_review_response(assignment, maps, review_final_versions, nil)
    end
    review_final_versions
  end

  def self.prepare_review_response(assignment, maps, review_final_versions, round)
    symbol = if round.nil?
               :review
             else
               ('review round' + ' ' + round.to_s).to_sym
             end
    review_final_versions[symbol] = {}
    review_final_versions[symbol][:questionnaire_id] = assignment.review_questionnaire_id(round)
    response_ids = []
    maps.each do |map|
      where_map = { map_id: map.id }
      where_map[:round] = round unless round.nil?
      responses = Response.where(where_map)
      response_ids << responses.last.id unless responses.empty?
    end
    review_final_versions[symbol][:response_ids] = response_ids
  end
end
