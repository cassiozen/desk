class AssigneeProfile < ActiveRecord::Base
  has_one :user, as: :profile, dependent: :destroy
  has_many :issues, foreign_key: "assignee_id"
  default_scope { includes(:user) }
end
