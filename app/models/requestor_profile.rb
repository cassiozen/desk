class RequestorProfile < ActiveRecord::Base
  has_one :user, as: :profile, dependent: :destroy
  has_many :issues, foreign_key: "requestor_id"
  default_scope { includes(:user) }
end
