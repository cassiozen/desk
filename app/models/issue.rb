class Issue < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller && controller.current_user }

  belongs_to :tenant
  belongs_to :requestor, class_name: "RequestorProfile", foreign_key: "requestor_id"
  belongs_to :assignee, class_name: "AssigneeProfile", foreign_key: "assignee_id"
  has_many :state_changes, class_name: "IssueState"
  has_many :interactions, dependent: :destroy
  has_many :messages, :through => :interactions, :source => :interacteable, :source_type => "Message"

  before_create :set_initial_state

  default_scope { where(tenant_id: Tenant.current_id) }


  #
  # STATE MACHINE
  #
  # Issues have a state-machine functionality through a polymorphic assossiation with IssueState
  # Not only records current_state but also state changes history
  #

  # Possible States
  STATES = %w[open pending closed]

  # Scope-like methods to find all issues on a given state
  def self.open
    joins(:state_changes).merge IssueState.with_last_state("open")
  end

  def self.pending
    joins(:state_changes).merge IssueState.with_last_state("pending")
  end

  def self.closed
    joins(:state_changes).merge IssueState.with_last_state("closed")
  end

  def self.overdue
    where("due_in < ?", DateTime.now)
  end

  def self.due_today
    now = DateTime.now
    where(:due_in => now..now.end_of_day)
  end


  # Get current state (with syntatic-sugar expressions for each possible state)
  delegate :open?, :closed?, :pending?, to: :current_state

  def fetch_current_state
    (state_changes.last.try(:state)).inquiry rescue nil
  end

  # Cache issue's current state
  def current_state
    Rails.cache.fetch([self, "current_state"]) { fetch_current_state }
  end

  def set_initial_state
    state_changes.build({state:'open'}) if fetch_current_state.nil?
  end

  # Transition state
  def change_state(state)
    raise ArgumentError, "Invalid state: #{state}" unless STATES.include? state
    state_changes.create! state: state unless fetch_current_state == state
  end

end