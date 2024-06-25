class ChapterService::Translator < ApplicationService
  def initialize(chapter:, source_language:, target_language:)
    @chapter = chapter
    @source_language = source_language
    @target_language = target_language
  end

  def self.call(chapter:, source_language:, target_language:)
    new(chapter: chapter, source_language: source_language, target_language: target_language).call
  end

  def call
    doc = Nokogiri::HTML.fragment(@chapter.content.body.to_s)
    html_segments = {}

    doc.children.each do |node|
      html_segments.merge! Hash[node.get_attribute('data-p-id'), node.to_html]
    end

    show_translate = @source_language.downcase != @target_language.downcase

    if show_translate
      cache_key = "translate_#{@target_language}_#{@chapter.id}"
      cache_translate = Rails.cache.fetch(cache_key)

      if cache_translate.nil? || cache_translate[:cached_at] <= @chapter.updated_at
        cache_translate = start_translate(html_segments)
        Rails.cache.write(cache_key, cache_translate)
      end
    end

    show_translate = cache_translate

    {
      original: {
        title: @chapter.title,
        content: html_segments
      },
      show_translate: show_translate,
      translated: cache_translate
    }
  end

  private

  def start_translate(html_segments)
    client = Google::Cloud::Translate.translation_service
    translated_title = client.translate_text(contents: [@chapter.title], mime_type: 'text/html', source_language_code: @source_language, target_language_code: @target_language, parent: "projects/#{ENV['CLOUD_PROJECT_ID']}")
    translated_content = client.translate_text(contents: html_segments.values, mime_type: 'text/html', source_language_code: @source_language, target_language_code: @target_language, parent: "projects/#{ENV['CLOUD_PROJECT_ID']}")
    translated_mapped = translated_content.translations.map(&:translated_text)
    translated_hashed = {}

    html_segments.each do |key, _value|
      translated_hashed[key] = translated_mapped[html_segments.keys.index(key)]
    end

    { title: translated_title.translations.first.translated_text, content: translated_hashed, cached_at: Time.now }
  end
end
