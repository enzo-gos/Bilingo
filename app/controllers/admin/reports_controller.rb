module Admin
  class ReportsController < BaseController
    def index
      @story_reports = StoryReport.includes([:reporter, { story: [:author, { cover_image_attachment: :blob }] }]).all.order(status: :asc, created_at: :desc)
    end

    def show
      @report = StoryReport.find(params[:id])
      authorize @report, policy_class: Admin::StoryReportPolicy

      @requests = @report.banned_requests
      @story = @report.story
    end

    def close
      @report_request = StoryReport.find(params[:id])
      authorize @report_request, policy_class: Admin::StoryReportPolicy

      @report_request.closed!

      redirect_back fallback_location: root_path, notice: 'Reported request was successfully closed.'
    end

    def accept
      @report_request = StoryReport.find(params[:id])
      authorize @report_request, policy_class: Admin::StoryReportPolicy

      @report_request.accepted!

      redirect_back fallback_location: root_path, notice: 'Reported request was successfully closed.'
    end

    private

    def report_request_params
      params.require(:report_request).permit(:title, :reason)
    end
  end
end
