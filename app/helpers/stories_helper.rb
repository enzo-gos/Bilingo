module StoriesHelper
  def story_meta(story)
    set_meta_tags(
      title: story.name,
      description: story.description.body.to_s,
      image: rails_blob_url(story.cover_image),
      keywords: "#{story.tag_list}, #{story.primary_genre.name}, #{story.secondary_genre&.name}",
      og: {
        title: story.name,
        description: story.description.body.to_s,
        image: rails_blob_url(story.cover_image)
      }
    )
  end
end
