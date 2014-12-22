class IssueState < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller && controller.current_user }

  belongs_to :issue, touch: true
  has_one :interaction, as: :interacteable

  validates_inclusion_of :state, in: Issue::STATES

  def self.with_last_state(state)
    where("issue_states.id IN (SELECT MAX(id) FROM issue_states GROUP BY issue_id) AND state = ?", state)
  end

end