class Message < ActiveRecord::Base
  has_one :interaction, as: :interacteable
end
