class Interaction < ActiveRecord::Base
  belongs_to :issue
  belongs_to :user
  belongs_to :interacteable, polymorphic: true, dependent: :destroy
  validates_presence_of :interacteable, allow_nil: false
end
