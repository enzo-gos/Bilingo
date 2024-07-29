class CommentsController < ApplicationController
  include CommentsHelper

  before_action :prepare_chapter, except: [:index]

  def index
    @chapter = Chapter.includes([comments: [:commenter, :rich_text_comment]]).find(params[:chapter_id])
    comments = @chapter.comments.group_by(&:paragraph_id).transform_values(&:first)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update('comment-body', partial: 'chapters/comment/comment_list', locals: { comments: comments, chapter_id: @chapter.id })
        ]
      end
    end
  end

  def show
    comment = Comment.new

    all_comment = @chapter.comments.includes([{ commenter: :author }, :rich_text_comment]).where(paragraph_id: params[:id])

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update('comment-body', partial: 'chapters/comment/comment_details', locals:
          {
            comment: comment,
            all_comment: all_comment,
            chapter: @chapter,
            paragraph_id: params[:id],
            author: current_user&.author == @chapter.story.author
          })
        ]
      end
    end
  end

  def create
    comment = @chapter.comments.new(comment_params)
    comment.commenter = current_user

    authorize comment

    respond_to do |format|
      format.turbo_stream do
        if comment.save
          render turbo_stream: [
            turbo_stream.update('comment-form', partial: 'chapters/comment/comment_form', locals:
            {
              comment: Comment.new,
              url: story_chapter_comments_path(story_id: @chapter.story_id, chapter_id: @chapter.id),
              paragraph_id: comment.paragraph_id,
              author: current_user == @chapter.story.author,
              mention: ''
            })
          ]
        else
          error = comment.errors.find { |err| err.attribute == :profanity_word }
          flash.now[:alert] = error.type if error.present?
          render turbo_stream: [
            turbo_stream.update('toast-flash', partial: 'shared/toast/container')
          ]
        end
      end
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    authorize comment

    comment.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: []
      end
    end
  end

  def reply
    comment = @chapter.comments.find(params[:comment_id])
    authorize comment

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update('comment-form', partial: 'chapters/comment/comment_form', locals:
          {
            comment: Comment.new,
            url: story_chapter_comments_path(story_id: @chapter.story_id, chapter_id: @chapter.id),
            paragraph_id: comment.paragraph_id,
            author: current_user == @chapter.story.author,
            mention: "#{view_context.link_to(comment.commenter.author.nickname, author_path(comment.commenter.author))}&nbsp;".html_safe
          })
        ]
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:comment, :paragraph_id)
  end

  def prepare_chapter
    @chapter = Chapter.find(params[:chapter_id])
  end
end
