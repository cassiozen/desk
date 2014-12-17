class RequestState < ActiveRecord::Base
  belongs_to :request, touch: true
  has_one :interaction, as: :interacteable
  validates_inclusion_of :state, in: Request::STATES

  def self.with_last_state(state)
    where("request_states.id IN (SELECT MAX(id) FROM request_states GROUP BY request_id) AND state = ?", state)
  end

end