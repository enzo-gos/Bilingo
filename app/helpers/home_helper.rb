module HomeHelper
  def format_stories(stories)
    stories.map do |story|
      {
        cover: story.cover_image,
        title: story.name,
        author: story.author.fullname,
        description: story.description,
        genres: story.genres.join(' / '),
        views: story.views,
        comments: '15K',
        chapters: story.chapters.size,
        url: story_path(story),
        share: share_path(story)
      }
    end
  end
end
