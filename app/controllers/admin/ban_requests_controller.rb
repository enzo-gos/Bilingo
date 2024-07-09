module Admin
  class BanRequestsController < BaseController
    before_action :prepare_story

    def new
      authorize [:admin, :banned_request], :new?
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update('request-form', partial: 'admin/stories/request_form', locals: { banned_request: BannedRequest.new, story: @story })
          ]
        end
        format.html
      end
    end

    def create
      @banned_request = BannedRequest.new(banned_request_params)
      authorize @banned_request, policy_class: Admin::BannedRequestPolicy

      @banned_request.story = @story
      @banned_request.requester = current_user

      respond_to do |format|
        format.turbo_stream do
          if @banned_request.save
            @story.update(banned: true)
            redirect_back fallback_location: root_path, notice: 'Banned request was successfully sent.'
          else
            render turbo_stream: [
              turbo_stream.update('request-form', partial: 'admin/stories/request_form', locals: { banned_request: @banned_request, story: @story })
            ]
          end
        end
        format.html
      end
    end

    def close
      @banned_request = BannedRequest.find(params[:id])
      authorize @banned_request, policy_class: Admin::BannedRequestPolicy

      @banned_request.update(status: BannedRequest.close_status)
      @story.update(banned: @story.banned_requests.where(status: [BannedRequest.open_status, BannedRequest.handle_status]).any?)

      redirect_back fallback_location: root_path, notice: 'Banned request was successfully closed.'
    end

    def accept
      @banned_request = BannedRequest.find(params[:id])
      authorize @banned_request, policy_class: Admin::BannedRequestPolicy

      @banned_request.update(status: BannedRequest.accept_status)
      @story.update(banned: @story.banned_requests.where(status: [BannedRequest.open_status, BannedRequest.handle_status]).any?)

      redirect_back fallback_location: root_path, notice: 'Banned request was successfully accepted.'
    end

    private

    def prepare_story
      @story = Story.find(params[:story_id])
    end

    def banned_request_params
      params.require(:banned_request).permit(:title, :reason)
    end
  end
end
