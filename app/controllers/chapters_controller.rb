class ChaptersController < ApplicationController
  def show
    @story = Story.find(params[:story_id])
    @chapter = Chapter.find(params[:id])

    @prev_chapter = @chapter.higher_item ? story_chapter_path(story_id: @story.id, id: @chapter.higher_item.id) : nil
    @next_chapter = @chapter.lower_item ? story_chapter_path(story_id: @story.id, id: @chapter.lower_item.id) : nil

    doc = Nokogiri::HTML.fragment(@chapter.content.body.to_s)
    @html_segments = []

    client = Google::Cloud::Translate.translation_service
    source_lang_code = @story.language_code.downcase

    doc.children.each do |node|
      @html_segments << node.to_html
    end

    @response = client.translate_text contents: @html_segments, mime_type: 'text/html', source_language_code: source_lang_code, target_language_code: 'vi', parent: "projects/#{ENV['CLOUD_PROJECT_ID']}"
    @translated_title = client.translate_text contents: [@chapter.title], mime_type: 'text/html', source_language_code: source_lang_code, target_language_code: 'vi', parent: "projects/#{ENV['CLOUD_PROJECT_ID']}"
  end
end
