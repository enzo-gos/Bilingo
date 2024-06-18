module Writer::ChaptersHelper
  def published_class(chapter)
    chapter.published ? 'next-btn' : 'save-btn'
  end
end
