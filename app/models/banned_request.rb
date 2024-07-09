class BannedRequest < ApplicationRecord
  STATUS = %w[Open Handled Accepted Closed].freeze

  belongs_to :story
  belongs_to :requester, class_name: :User

  has_rich_text :reason

  validates :title,
            :reason,
            presence: true

  def status_str
    STATUS[status]
  end

  def closed?
    status == BannedRequest.close_status
  end

  def accepted?
    status == BannedRequest.accept_status
  end

  class << self
    def open_status
      STATUS.index('Open')
    end

    def handle_status
      STATUS.index('Handled')
    end

    def accept_status
      STATUS.index('Accepted')
    end

    def close_status
      STATUS.index('Closed')
    end
  end
end
