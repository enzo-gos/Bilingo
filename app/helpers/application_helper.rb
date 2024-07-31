module ApplicationHelper
  include Pagy::Frontend

  def default_meta_tags
    {
      site: 'Bilingo',
      title: 'Home',
      reverse: true,
      separator: '|',
      description: "#{t('footer.description')} #{t('footer.description_continued')}",
      keywords: 'multilingual storytelling, AI-powered story reading, language learning stories, multilingual literature, AI narration, interactive stories, language translation stories, AI language support, bilingual storybooks, voice-assisted reading, AI story narrator, language diversity stories, multilingual audiobooks, AI reading companion, cross-language storytelling',
      canonical: request.original_url,
      noindex: !Rails.env.production?,
      og: {
        site_name: 'Bilingo',
        title: 'Home',
        description: "#{t('footer.description')} #{t('footer.description_continued')}",
        type: 'website',
        url: request.original_url,
        image: image_url('favicon.ico')
      }
    }
  end

  def all_genres
    Genre.all
  end

  def all_topics
    ActsAsTaggableOn::Tag.for_context(:tags).most_used(12)
  end

  def top_story
    Story.with_published.top_viewed.includes([:author, { cover_image_attachment: :blob }, :rich_text_description]).map do |story|
      {
        cover: story.cover_image,
        title: story.name,
        author: story.author.nickname,
        description: story.description.body.to_plain_text,
        views: story.views,
        comments: story.comments,
        chapters: story.number_of_published,
        url: story_path(story)
      }
    end
  end

  def recently_read
    Story.recently_read(request.remote_ip).includes([:author, { cover_image_attachment: :blob }, :rich_text_description]).map do |story|
      {
        cover: story.cover_image,
        title: story.name,
        author: story.author.nickname,
        description: story.description.body.to_plain_text,
        views: story.views,
        comments: story.comments,
        chapters: story.number_of_published,
        url: story_path(story)
      }
    end
  end

  def locales
    [
      {
        name: 'Tiếng việt',
        code: 'vi',
        flag: 'icons/locales/vi.svg'
      },
      {
        name: 'English',
        code: 'en',
        flag: 'icons/locales/en.svg'
      },
      {
        name: '中文',
        code: 'zh',
        flag: 'icons/locales/zh.svg'
      }
    ]
  end

  def current_locale
    I18n.locale
  end

  def format_notification(count)
    count > 99 ? '99+' : count.to_s
  end
end
