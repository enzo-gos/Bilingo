# spec/models/story_report_spec.rb

require 'rails_helper'

RSpec.describe StoryReport, type: :model do
  describe 'associations' do
    it { should belong_to(:story) }
    it { should belong_to(:reporter).class_name('User') }
    it { should have_many(:banned_requests) }
    it { should have_many(:notification_mentions) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:reason) }
  end

  describe 'rich text' do
    it 'has rich text for reason' do
      expect(StoryReport.new).to respond_to(:reason)
    end
  end

  describe 'enums' do
    it 'defines enum for status' do
      expect(StoryReport.statuses).to include('open', 'accepted', 'closed')
    end
  end

  describe 'private methods' do
    describe '#send_notifications' do
      it 'sends notifications to admins after create' do
        admin = create(:user, :admin)
        story_report = create(:story_report)

        expect(ReportNotifier).to receive_message_chain(:with, :deliver).with(record: story_report, icon: :report).with([admin])
        story_report.send(:send_notifications)

        expect(admin.unread_notifications_count).to eq(1)
        notification = admin.notifications.first.event

        expect(notification.message).to eq("Reason: #{story_report.reason}".html_safe)
        expect(notification.title).to eq("<b>#{story_report.reporter.fullname}</b> has reported <b>#{story_report.story.name}</b>".html_safe)
        expect(notification.icon).to eq(:report)

        url = notification.destination_path
        expect(url).to eq(Rails.application.routes.url_helpers.admin_report_path(id: story_report.id))
      end
    end
  end
end
