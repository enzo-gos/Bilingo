module Admin
  class StoriesController < BaseController
    before_action :prepare_story, except: [:index]
    before_action :prepare_banned_requests, only: [:delete]

    def index
      story_list = Story.includes([:author, { cover_image_attachment: :blob }]).all.order(:id)
      @pagy, @stories = pagy(story_list)
    end

    def show
      start_date = Date.current.beginning_of_month
      end_date = Date.current.end_of_month

      views_data = @story.story_views
        .where(viewed_on: start_date..end_date)
        .group(:viewed_on)
        .count

      @views_by_day = (start_date..end_date).each_with_object({}) { |date, hash| hash[date] = 0 }
      @views_by_day.merge!(views_data)
    end

    def destroy
      @story.destroy
      redirect_to admin_stories_path, notice: 'Story was successfully deleted.'
    end

    def ban
      @story.update(banned: true)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(helpers.dom_id(@story), partial: 'admin/shared/story_row', locals: { story: @story })
          ]
        end
        format.html { redirect_to admin_stories_path, notice: 'Story was successfully banned.' }
      end
    end

    def unban
      @story.update(banned: false)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(helpers.dom_id(@story), partial: 'admin/shared/story_row', locals: { story: @story })
          ]
        end
        format.html { redirect_to admin_stories_path, notice: 'Story was successfully unlocked.' }
      end
    end

    private

    def prepare_story
      @story = Story.find(params[:id])
      authorize @story, policy_class: Admin::StoryPolicy
    end

    def prepare_banned_requests
      @requests = @story.banned_requests.includes([:rich_text_reason])
    end
  end
end
