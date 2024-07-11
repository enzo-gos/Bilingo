class AddStoryReportToBannedRequests < ActiveRecord::Migration[7.1]
  def change
    add_reference :banned_requests, :story_report, index: true, null: true
  end
end
