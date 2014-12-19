class User < ActiveRecord::Base
  belongs_to :tenant
  belongs_to :profile, polymorphic: true, dependent: :destroy
  has_many :interactions
  default_scope { where(tenant_id: Tenant.current_id) }

  # Include default devise modules. Others available are:
  #  :confirmable, :validatable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, request_keys: [:subdomain]

  # Overriding Devise find auth method to include the tenant_id additional query parameters
  def self.find_for_authentication(warden_conditions)
    tenant = Tenant.find_by_url!(warden_conditions[:subdomain]) rescue nil
    where(:email => warden_conditions[:email], :tenant_id => tenant.id).first
  end
end
