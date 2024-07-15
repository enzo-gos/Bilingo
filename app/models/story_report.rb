class StoryReport < ApplicationRecord
  belongs_to :story
  belongs_to :reporter, class_name: :User

  has_many :banned_requests, dependent: :destroy
  has_many :notification_mentions, as: :record, dependent: :destroy, class_name: 'Noticed::Event'

  has_rich_text :reason

  validates :title,
            :reason,
            presence: true

  enum :status, [:open, :accepted, :closed], validate: true

  after_create_commit :send_notifications

  private

  def send_notifications
    ReportNotifier.with(record: self, icon: :report).deliver(User.with_role(:admin))
  end
end
