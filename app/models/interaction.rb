class Interaction < ActiveRecord::Base
  belongs_to :request
  belongs_to :user
  belongs_to :interacteable, polymorphic: true
  validates_presence_of :interacteable, allow_nil: false
end
