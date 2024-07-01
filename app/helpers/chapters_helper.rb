module ChaptersHelper
  def current_translate
    params[:translate_code]
  end

  def page_settings
    {
      font_size: {
        list: [10, 11, 12, 13, 14, 15, 16, 17, 18, 20, 22, 24, 26, 28, 32],
        default: 13
      },
      p_space: {
        min: 16,
        max: 40,
        default: 16
      },
      translation: {
        list: [[true, 'block'], [false, 'none']],
        default: true
      }
    }
  end

  def has_comment?(p_id, chapter)
    comments = chapter.comments.where(paragraph_id: p_id)
    comments.exists?
  end

  def count_comment(p_id, chapter)
    comments = chapter.comments.where(paragraph_id: p_id)
    comments&.size
  end
end
