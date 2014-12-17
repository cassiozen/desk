class RequestorProfile < ActiveRecord::Base
  has_one :user, as: :profile, dependent: :destroy
  has_many :requests, foreign_key: "requestor_id"
end
