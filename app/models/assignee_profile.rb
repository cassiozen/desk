class AssigneeProfile < ActiveRecord::Base
  has_one :user, as: :profile, dependent: :destroy
  has_many :assignments, class_name: "Issue", foreign_key: "assignee_id"
  default_scope { includes(:user) }
end
