class User < ActiveRecord::Base
  belongs_to :tenant
  belongs_to :profile, polymorphic: true, dependent: :destroy
  has_many :interactions
  delegate :issues, :to => :profile
  acts_as_reader
  default_scope { where(tenant_id: Tenant.current_id) }

  # Include default devise modules. Others available are:
  #  :confirmable, :validatable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable


end
