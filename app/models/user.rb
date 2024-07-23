class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[facebook]

  has_many :stories, -> { includes([cover_image_attachment: :blob]).order(position: :asc) }, foreign_key: :author
  has_many :comments, foreign_key: :commenter
  has_many :notifications, -> { includes([{ event: { record: [:rich_text_reason, :reporter, :author, { story: [:author] }, :story_report] } }]).order(created_at: :desc) }, as: :recipient, dependent: :destroy, class_name: 'Noticed::Notification'
  has_many :notification_mentions, as: :record, dependent: :destroy, class_name: 'Noticed::Event'

  acts_as_voter

  validates :first_name, :last_name, presence: true

  def active_for_authentication?
    super && account_active?
  end

  def account_active?
    active == true
  end

  def self.from_omniauth(auth)
    name_split = auth.info.name.split

    User.find_or_create_by!(email: auth.info.email) do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.last_name = name_split[0]
      user.first_name = name_split[1]
      user.avatar = auth.info.image
      user.password = Devise.friendly_token[0, 20]
      user.add_role :user
    end
  end

  def fullname
    "#{first_name} #{last_name}"
  end

  def unread_notifications_count
    notifications.unread.size
  end
end
