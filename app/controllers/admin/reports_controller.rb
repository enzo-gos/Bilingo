module Admin
  class ReportsController < BaseController
    before_action :prepare_report, except: [:index]

    def index
      @story_reports = StoryReport.includes([:reporter, { story: [:author, { cover_image_attachment: :blob }] }]).all.order(status: :asc, created_at: :desc)
    end

    def show
      @requests = @report.banned_requests
      @story = @report.story
    end

    def close
      @report.closed!
      redirect_back fallback_location: root_path, notice: 'Reported request was successfully closed.'
    end

    def accept
      @report.accepted!
      redirect_back fallback_location: root_path, notice: 'Reported request was successfully closed.'
    end

    private

    def report_request_params
      params.require(:report_request).permit(:title, :reason)
    end

    def prepare_report
      @report = StoryReport.find(params[:id])
      authorize @report, policy_class: Admin::StoryReportPolicy
    end
  end
end
