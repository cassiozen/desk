class Message < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller && controller.current_user }

  has_one :interaction, as: :interacteable
  has_many :attachments

  delegate :user, :to => :interaction, :allow_nil => true

  acts_as_readable :on => :created_at
end
