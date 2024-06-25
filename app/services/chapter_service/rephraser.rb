class ChapterService::Rephraser < ApplicationService
  def initialize(chapter:, dest_language:, original:, translated:, model: 'gemini-1.5-flash')
    @chapter = chapter
    @original = original
    @translated = translated
    @model = model
    @dest_language = dest_language
  end

  def self.call(chapter:, dest_language:, original:, translated:, model: 'gemini-1.5-flash')
    new(chapter: chapter, dest_language: dest_language, original: original, translated: translated, model: model).call
  end

  def call
    try = 0
    begin
      try += 1
      rephrased = gemini(original: @original, translated: @translated)
    rescue Faraday::TooManyRequestsError
      retry if try < 5
      error = true
    end
    ServiceResponse.new(payload: rephrased, errors: error)
  end

  private

  def gemini(original:, translated:)
    client = Gemini.new(
      credentials: {
        service: 'generative-language-api',
        api_key: ENV['GPT_API_KEY']
      },
      options: { model: @model, server_sent_events: true }
    )

    client.generate_content(
      { contents: [
        { role: 'model', parts: { text: 'You will be given two HTML texts: one containing original content and another with the same content translated into any language. Your objective is to refine the translated text to ensure it is fluent, accurate in meaning, and matches the structure and context of the original content. Instructions: 1. Understand the Original Content: Begin by comprehending the meaning, message, and context conveyed in the original content. 2. Compare and Adjust: Analyze the translated content, identifying and correcting errors in translation, awkward sentences, and ensuring the translated text faithfully conveys the original meaning. 3. Maintain HTML Structure: It is crucial to preserve the HTML structure of the translated snippet while making revisions for clarity and accuracy. Input: original_html: HTML-formatted original content. translated_html: HTML-formatted translated content. Process: 1. Receive original_html and translated_html as inputs. 2. Compare each paragraph and sentence in translated_html with original_html. 3. Edit the translated text to rectify translation errors, improve clarity, and ensure it accurately reflects the intended meaning of the original content. I will provide you with the original_html and translated_html. You just need to return the processed result to me without any explanation or anything else. Please notice that the result can not be difference language from translated language!' } },
        { role: 'user', parts: { text: "original_html: #{original}, translated_html: #{translated}" } }
      ] }
    ) do |event, _parsed, _raw|
      return translated if event['candidates'].first['content'].nil?

      return event['candidates'].first['content']['parts'].first['text'].strip
    end
  end
end
