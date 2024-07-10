class ReportsController < ApplicationController
  before_action :auth_user
  before_action :prepare_story

  def new
    @report_request = StoryReport.new
  end

  def create
    @report_request = StoryReport.new(report_request_params)
    @report_request.story = @story
    @report_request.reporter = current_user

    if @report_request.save
      redirect_to story_path(@story), notice: 'Report was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def report_request_params
    params.require(:story_report).permit(:title, :reason)
  end

  def prepare_story
    @story = Story.find(params[:story_id])
  end

  def auth_user
    unless user_signed_in?
      flash[:info] = t('auth.not_signed_in')
      redirect_to root_path
    end
  end
end
