require 'rails_helper'

RSpec.describe ChapterService::Summarizer do
  let(:chapter) { create(:chapter) }
  let(:target_language) { 'es' }
  let(:content) { '<p>This is a test story.</p>' }
  let(:model) { 'gemini-1.5-flash' }
  let(:summarized_content) { 'Esta es una historia de prueba.' }
  let(:gemini_client) { instance_double('GeminiClient') }

  before do
    stub_const('Gemini', Class.new do
      def self.new(*)
        GeminiClient.new
      end
    end)

    stub_const('GeminiClient', Class.new do
      def generate_content(*)
        yield({ 'candidates' => [{ 'content' => { 'parts' => [{ 'text' => 'Summarized content' }] } }] }, nil, nil)
      end
    end)

    allow(GeminiClient).to receive(:new).and_return(gemini_client)
    allow(gemini_client).to receive(:generate_content).and_yield({ 'candidates' => [{ 'content' => { 'parts' => [{ 'text' => summarized_content }] } }] }, nil, nil)

    # Stub Rails.cache for all contexts
    allow(Rails.cache).to receive(:fetch)
    allow(Rails.cache).to receive(:write)
  end

  describe '.call' do
    it 'instantiates and calls the service' do
      expect(described_class).to receive(:new).with(
        chapter: chapter,
        target_language: target_language,
        content: content,
        model: model,
        cached: true
      ).and_call_original

      described_class.call(
        chapter: chapter,
        target_language: target_language,
        content: content,
        model: model
      )
    end
  end

  describe '#call' do
    subject { described_class.new(chapter: chapter, target_language: target_language, content: content, model: model) }

    context 'when cache is empty' do
      before do
        allow(Rails.cache).to receive(:fetch).and_return(nil)
      end

      it 'generates a new summary and caches it' do
        result = subject.call

        expect(result).to eq(summarized_content)
        expect(Rails.cache).to have_received(:write).with(
          "summary_#{target_language}_#{chapter.id}",
          { data: summarized_content, cached_at: anything }
        )
      end
    end

    context 'when cache exists but is outdated' do
      before do
        allow(Rails.cache).to receive(:fetch).and_return({ data: 'Old summary', cached_at: 1.day.ago })
        allow(chapter).to receive(:updated_at).and_return(Time.now)
      end

      it 'generates a new summary and updates the cache' do
        result = subject.call

        expect(result).to eq(summarized_content)
        expect(Rails.cache).to have_received(:write).with(
          "summary_#{target_language}_#{chapter.id}",
          { data: summarized_content, cached_at: anything }
        )
      end
    end

    context 'when cache exists and is up-to-date' do
      let(:cached_summary) { 'Cached summary' }

      before do
        allow(Rails.cache).to receive(:fetch).and_return({ data: cached_summary, cached_at: Time.now })
        allow(chapter).to receive(:updated_at).and_return(1.day.ago)
      end

      it 'returns the cached summary' do
        result = subject.call

        expect(result).to eq(cached_summary)
        expect(Rails.cache).not_to have_received(:write)
      end
    end

    context 'when Gemini API fails' do
      it 'retries on TooManyRequestsError' do
        call_count = 0
        allow(gemini_client).to receive(:generate_content) do |&block|
          call_count += 1
          if call_count < 3
            raise Faraday::TooManyRequestsError
          else
            block.call({ 'candidates' => [{ 'content' => { 'parts' => [{ 'text' => summarized_content }] } }] }, nil, nil)
          end
        end

        allow(Rails.cache).to receive(:fetch).and_return(nil)

        result = subject.call

        expect(result).to eq(summarized_content)
        expect(call_count).to eq(3)
      end
    end
  end
end
