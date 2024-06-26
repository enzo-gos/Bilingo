class ChaptersController < ApplicationController
  before_action :prepare_story
  before_action :prepare_chapter
  before_action :prepare_translation

  def show
    params[:translate_code] ||= params[:locale]
    @prev_chapter = @chapter.higher_item ? story_chapter_path(story_id: @story.id, id: @chapter.higher_item.id) : nil
    @next_chapter = @chapter.lower_item ? story_chapter_path(story_id: @story.id, id: @chapter.lower_item.id) : nil

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update('translate-dropdown', partial: 'translate_dropdown', locals: { current_translate: params[:translate_code] }),
          turbo_stream.update('story-content', partial: 'story_content', locals: { original: @translation[:original], translated: @translation[:translated], rephrases: @rephrasers, show_translate: @translation[:show_translate] })
        ]
      end
      format.html
    end
  end

  def translate
    index = params[:index]

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("translate_#{index}", @translation[:translated][:content][index]),
          turbo_stream.update("translate_info_#{index}", t('chapter.translated_by', by: 'Google')),
          turbo_stream.remove("rephrase_#{index}")
        ]
      end
    end
  end

  def rephrase
    index = params[:index]

    original = @translation[:original][:content][index]
    translated = @translation[:translated][:content][index]
    response = ChapterService::Rephraser.call(chapter: @chapter, target_language: params[:translate_code], index: index, original: original, translated: translated)

    error = response.errors
    rephrased = response.payload

    respond_to do |format|
      format.turbo_stream do
        if error
          render turbo_stream: [
            turbo_stream.update("translate_#{index}", translated),
            turbo_stream.remove("rephrase_#{index}")
          ]
        else
          render turbo_stream: [
            turbo_stream.update("translate_#{index}", rephrased),
            turbo_stream.update("translate_info_#{index}", t('chapter.rephrased_by', by: 'Gemini')),
            turbo_stream.remove("rephrase_#{index}")
          ]
        end
      end
    end
  end

  def rephrase_alt
    index = params[:index]

    original = @translation[:original][:content][index]
    translated = @translation[:translated][:content][index]

    old_response = ChapterService::Rephraser.call(chapter: @chapter, target_language: params[:translate_code], index: index, original: original, translated: translated)
    response = ChapterService::Rephraser.call(chapter: @chapter, target_language: params[:translate_code], index: index, original: original, translated: old_response.payload, cached: false, model: 'gemini-1.5-pro')

    error = response.errors
    rephrased = response.payload

    respond_to do |format|
      format.turbo_stream do
        if error
          render turbo_stream: [
            turbo_stream.update("translate_#{index}", translated),
            turbo_stream.remove("rephrase_#{index}")
          ]
        else
          render turbo_stream: [
            turbo_stream.update("translate_#{index}", rephrased),
            turbo_stream.update("translate_info_#{index}", t('chapter.rephrased_by', by: 'Gemini')),
            turbo_stream.remove("rephrase_#{index}")
          ]
        end
      end
    end
  end

  def summarize
    original = ChapterService::Summarizer.call(chapter: @chapter, target_language: @story.language_code.downcase, content: @chapter.content.body.to_s)
    translated = ChapterService::Summarizer.call(chapter: @chapter, target_language: params[:translate_code], content: original)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update('original-summary', original),
          turbo_stream.update('summary-info', t('chapter.rephrased_by', by: 'Gemini')),
          turbo_stream.update('translated-summary', partial: 'translated_summary', locals: { content: translated })
        ]
      end
    end
  end

  def prepare_story
    @story = Story.find(params[:story_id])
  end

  def prepare_chapter
    @chapter = Chapter.find(params[:id])
  end

  def prepare_translation
    params[:translate_code] ||= params[:locale]
    @translation = ChapterService::Translator.call(chapter: @chapter, source_language: @story.language_code, target_language: params[:translate_code])
  end
end
