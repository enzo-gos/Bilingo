class BannedRequest < ApplicationRecord
  belongs_to :story
  belongs_to :requester, class_name: :User
  belongs_to :story_report, optional: true

  has_many :notification_mentions, as: :record, dependent: :destroy, class_name: 'Noticed::Event'

  has_rich_text :reason

  validates :title,
            :reason,
            presence: true

  enum :status, [:open, :handled, :accepted, :closed], validate: true

  after_save_commit :send_notifications

  private

  def send_notifications
    BannedRequestNotifier.with(record: self, icon: :report).deliver(story.author) if accepted? || open?
  end
end
