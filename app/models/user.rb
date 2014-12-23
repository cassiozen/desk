class User < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
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

  def picture
    if self.avatar?
      self.avatar.url
    else
      gravatar_id = Digest::MD5.hexdigest(self.email.downcase)
      "http://gravatar.com/avatar/#{gravatar_id}.png?s=60&d=identicon"
    end
  end

end
