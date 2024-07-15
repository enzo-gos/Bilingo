class ReportsController < ApplicationController
  before_action :auth_user
  before_action :prepare_story
  before_action :prepare_request, only: [:show, :solved]

  def new
    @report_request = StoryReport.new
  end

  def create
    @report_request = StoryReport.new(report_request_params)
    @report_request.story = @story
    @report_request.reporter = current_user

    if @report_request.save
      redirect_to story_path(@story), notice: t('report_story.success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def solved
    @request.handled!
    redirect_back fallback_location: root_path, notice: 'Reported request was successfully mark as solved.'
  end

  private

  def report_request_params
    params.require(:story_report).permit(:title, :reason)
  end

  def prepare_story
    @story = Story.find(params[:story_id])
  end

  def prepare_request
    @request = BannedRequest.find(params[:id])
    authorize @request
  end

  def auth_user
    unless user_signed_in?
      flash[:info] = t('auth.not_signed_in')
      redirect_to root_path
    end
  end
end
