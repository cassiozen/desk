class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  #  :confirmable, :validatable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, request_keys: [:subdomain]

  # Overriding Devise find auth method to include the portal_id additional query parameters
  def self.find_for_authentication(warden_conditions)
    Rails.logger.debug("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
    Rails.logger.debug(warden_conditions)
    portal = Portal.find_by_url!(warden_conditions[:subdomain]) rescue nil
    where(:email => warden_conditions[:email], :portal_id => portal.id).first
  end
end
