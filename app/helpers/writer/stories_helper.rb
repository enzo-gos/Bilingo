module Writer::StoriesHelper
  def fake_languages
    [
      { code: 'en', language: 'English' },
      { code: 'fr', language: 'Français' },
      { code: 'it', language: 'Italiano' },
      { code: 'de', language: 'Deutsch' },
      { code: 'es', language: 'Español' },
      { code: 'pt', language: 'Português' },
      { code: 'ca', language: 'Català' },
      { code: 'vi', language: 'Tiếng Việt' },
      { code: 'fil', language: 'Filipino' },
      { code: 'id', language: 'Bahasa Indonesia' },
      { code: 'ms', language: 'Bahasa Melayu' },
      { code: 'th', language: 'ภาษาไทย' },
      { code: 'ru', language: 'Русский' },
      { code: 'ro', language: 'Română' },
      { code: 'tr', language: 'Türkçe' },
      { code: 'cs', language: 'Česky' },
      { code: 'pl', language: 'Polski' },
      { code: 'hu', language: 'Magyar' },
      { code: 'el', language: 'ελληνικά' },
      { code: 'et', language: 'Eesti' },
      { code: 'lv', language: 'Latviešu' },
      { code: 'lt', language: 'Lietuvių' },
      { code: 'bs', language: 'Босански' },
      { code: 'sr', language: 'Српски' },
      { code: 'hr', language: 'Hrvatski' },
      { code: 'bg', language: 'Български' },
      { code: 'sk', language: 'Slovenčina' },
      { code: 'sl', language: 'Slovenščina' },
      { code: 'be', language: 'Беларускі' },
      { code: 'uk', language: 'Українська' },
      { code: 'sv', language: 'Svenska' },
      { code: 'no', language: 'Norsk' },
      { code: 'fi', language: 'Suomi' },
      { code: 'da', language: 'Dansk' },
      { code: 'nl', language: 'Nederlands' },
      { code: 'is', language: 'Íslenska' },
      { code: 'zh-cn', language: '简体中文' },
      { code: 'zh-tw', language: '繁體中文' },
      { code: 'ja', language: '日本語' },
      { code: 'ko', language: '한국어' },
      { code: 'ar', language: 'العربية' },
      { code: 'gu', language: 'ગુજરાતી' },
      { code: 'he', language: 'עברית' },
      { code: 'hi', language: 'हिन्दी' },
      { code: 'ml', language: 'മലയാളം' },
      { code: 'or', language: 'ଓଡ଼ିଆ' },
      { code: 'fa', language: 'فارسی' },
      { code: 'pa', language: 'ਪੰਜਾਬੀ' },
      { code: 'as', language: 'অসমীয়া' },
      { code: 'bn', language: 'বাংলা' },
      { code: 'ta', language: 'தமிழ்' },
      { code: 'sw', language: 'Kiswahili' },
      { code: 'af', language: 'Afrikaans' },
      { code: 'mr', language: 'मराठी' },
      { code: 'other', language: 'Other' }
    ].map { |lang| [lang[:language], lang[:code]] }
  end

  def format_my_stories(my_stories)
    my_stories.map do |story|
      {
        id: story.id,
        title: story.name,
        language: story.language_code,
        description: story.description,
        cover: story.cover_image,
        updated: story.updated_at.strftime('%b %d, %Y'),
        published: 1,
        draft: 8,
        views: '1M',
        comments: '10K'
      }
    end
  end

  def fake_chapters
    [
      {
        id: 1,
        title: 'Part 1',
        views: 1000,
        comments: 100,
        updated: Time.now.strftime('%b %d, %Y'),
        published: false
      },
      {
        id: 2,
        title: 'Part 2',
        views: 400,
        comments: 200,
        updated: Time.now.strftime('%b %d, %Y'),
        published: true
      },
      {
        id: 3,
        title: 'Part 3',
        views: 200,
        comments: 300,
        updated: Time.now.strftime('%b %d, %Y'),
        published: false
      },
      {
        id: 4,
        title: 'Part 4',
        views: 500,
        comments: 400,
        updated: Time.now.strftime('%b %d, %Y'),
        published: true
      }
    ]
  end

  def updatable_content(updatable)
    updatable ? 'content hidden' : 'content'
  end
end
