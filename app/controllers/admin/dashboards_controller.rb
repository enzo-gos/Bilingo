module Admin
  class DashboardsController < BaseController
    layout 'admin/base'

    def index
      start_date = Date.current.beginning_of_month
      end_date = Date.current.end_of_month

      @views_by_day = (start_date..end_date).each_with_object({}) { |date, hash| hash[date] = 0 }

      views_data = Story.joins(:story_views)
        .where(story_views: { viewed_on: start_date..end_date })
        .group('story_views.viewed_on')
        .count

      @views_by_day.merge!(views_data)
      @analysis_data = {
        views: views_data.values.sum,
        users: User.count,
        stories: Story.count
      }
    end
  end
end
