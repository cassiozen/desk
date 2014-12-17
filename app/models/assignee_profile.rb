class AssigneeProfile < ActiveRecord::Base
  has_one :user, as: :profile, dependent: :destroy
  has_many :assignments, class_name: "Request", foreign_key: "assignee_id"
end
