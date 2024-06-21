class ChapterService::Translator < ApplicationService
  def self.call(chapter:, source_language:, target_language:)
    doc = Nokogiri::HTML.fragment(chapter.content.body.to_s)
    html_segments = []

    doc.children.each do |node|
      html_segments << node.to_html
    end

    client = Google::Cloud::Translate.translation_service
    show_translate = source_language.downcase != target_language.downcase

    if show_translate
      translated_content = client.translate_text(contents: html_segments, mime_type: 'text/html', source_language_code: source_language, target_language_code: target_language, parent: "projects/#{ENV['CLOUD_PROJECT_ID']}")
      translated_title = client.translate_text(contents: [chapter.title], mime_type: 'text/html', source_language_code: source_language, target_language_code: target_language, parent: "projects/#{ENV['CLOUD_PROJECT_ID']}")
    end

    {
      original: {
        title: chapter.title,
        content: html_segments
      },
      show_translate: show_translate,
      translated: {
        title: translated_title,
        content: translated_content
      }
    }
  end
end
