class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[facebook]

  has_many :stories, -> { includes([cover_image_attachment: :blob]).order(position: :asc) }, foreign_key: :author
  has_many :comments, foreign_key: :commenter

  validates :first_name, :last_name, presence: true

  def active_for_authentication?
    super && account_active?
  end

  def account_active?
    active == true
  end

  def self.from_omniauth(auth)
    name_split = auth.info.name.split

    fuser = User.find_or_create_by!(email: auth.info.email) do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.last_name = name_split[0]
      user.first_name = name_split[1]
      user.avatar = auth.info.image
      user.password = Devise.friendly_token[0, 20]
      user.add_role :user
    end

    fuser.account_active? ? fuser : nil
  end

  def fullname
    "#{first_name} #{last_name}"
  end
end
