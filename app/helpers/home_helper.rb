module HomeHelper
  def format_stories(stories)
    stories.map do |story|
      {
        id: story.id,
        cover: story.cover_image,
        title: story.name,
        author: story.author.nickname,
        author_id: story.author.id,
        description: story.description.body.to_plain_text,
        genres: story.genres.join(' / '),
        views: story.views,
        comments: story.comments,
        chapters: story.number_of_published,
        url: story_path(story),
        share: share_path(story)
      }
    end
  end
end
