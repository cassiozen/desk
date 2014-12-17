class Request < ActiveRecord::Base
  belongs_to :portal
  belongs_to :requestor, class_name: "RequestorProfile", foreign_key: "requestor_id"
  belongs_to :assignee, class_name: "AssigneeProfile", foreign_key: "assignee_id"
  has_many :state_changes, class_name: "RequestState"
  before_create :set_initial_state


  #
  # STATE MACHINE
  #
  # Requests have a state-machine functionality through a polymorphic assossiation with RequestState
  # Not only records current_state but also state changes history
  #

  # Possible States
  STATES = %w[open pending closed]

  # Scope-like methods to find all requests on a given state
  def self.open_requests
    joins(:state_changes).merge RequestState.with_last_state("open")
  end

  def self.pending_requests
    joins(:state_changes).merge RequestState.with_last_state("pending")
  end

  def self.closed_requests
    joins(:state_changes).merge RequestState.with_last_state("closed")
  end

  # Get current state (with syntatic-sugar expressions for each possible state)
  delegate :open?, :closed?, :pending?, to: :current_state

  def fetch_current_state
    (state_changes.last.try(:state)).inquiry rescue nil
  end

  # Cache request's current state
  def current_state
    Rails.cache.fetch([self, "current_state"]) { fetch_current_state }
  end

  def set_initial_state
    state_changes.build({state:'open'}) if fetch_current_state.nil?
  end

  # Transition state methods
  def close
    state_changes.create! state: "closed" if open? or pending?
  end

  def reopen
    state_changes.create! state: "open" if closed? or pending?
  end

  def pend
    state_changes.create! state: "pending" if open? # Can't go from closed to pending
  end

end