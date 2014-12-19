class Message < ActiveRecord::Base
  has_one :interaction, as: :interacteable
  delegate :user, :to => :interaction, :allow_nil => true
  acts_as_readable :on => :created_at
end
