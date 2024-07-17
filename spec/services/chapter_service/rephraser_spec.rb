require 'rails_helper'

RSpec.describe ChapterService::Rephraser do
  let(:chapter) { create(:chapter) }
  let(:target_language) { 'es' }
  let(:index) { 1 }
  let(:original) { '<p>Hello, world!</p>' }
  let(:translated) { '<p>¡Hola, mundo!</p>' }
  let(:rephrased) { '<p>¡Hola, mundo maravilloso!</p>' }
  let(:model) { 'gemini-1.5-flash' }
  let(:gemini_client) { instance_double('GeminiClient') }
  let(:service_response) { instance_double(ServiceResponse) }

  before do
    stub_const('Gemini', Class.new do
      def self.new(*)
        GeminiClient.new
      end
    end)

    stub_const('GeminiClient', Class.new do
      def generate_content(*)
        yield({ 'candidates' => [{ 'content' => { 'parts' => [{ 'text' => 'Rephrased content' }] } }] }, nil, nil)
      end
    end)

    allow(ServiceResponse).to receive(:new).and_return(service_response)
  end

  describe '.call' do
    it 'instantiates and calls the service' do
      expect(described_class).to receive(:new).with(
        chapter: chapter,
        target_language: target_language,
        index: index,
        original: original,
        translated: translated,
        cached: true,
        model: model
      ).and_call_original

      described_class.call(
        chapter: chapter,
        target_language: target_language,
        index: index,
        original: original,
        translated: translated,
        model: model
      )
    end
  end

  describe '#call' do
    subject { described_class.new(chapter: chapter, target_language: target_language, index: index, original: original, translated: translated, model: model) }

    context 'when caching is enabled' do
      it 'uses cached response if available and not outdated' do
        cache_key = "rephrase_#{target_language}_#{chapter.id}"
        cached_data = { data: { index => rephrased }, cached_at: Time.now }
        allow(Rails.cache).to receive(:fetch).with(cache_key).and_return(cached_data)

        expect(subject.call).to eq(service_response)
        expect(ServiceResponse).to have_received(:new).with(payload: rephrased, errors: nil)
      end

      it 'generates new response if cache is outdated' do
        cache_key = "rephrase_#{target_language}_#{chapter.id}"
        outdated_cache = { data: { index => rephrased }, cached_at: 1.day.ago }
        allow(Rails.cache).to receive(:fetch).with(cache_key).and_return(outdated_cache)
        allow(Rails.cache).to receive(:write)

        expect(subject.call).to eq(service_response)
        expect(ServiceResponse).to have_received(:new).with(payload: 'Rephrased content', errors: nil)
        expect(Rails.cache).to have_received(:write).with(cache_key, { data: { index => 'Rephrased content' }, cached_at: anything })
      end

      it 'generates new response if cache is missing for the index' do
        cache_key = "rephrase_#{target_language}_#{chapter.id}"
        incomplete_cache = { data: { 2 => 'other rephrased content' }, cached_at: Time.now }
        allow(Rails.cache).to receive(:fetch).with(cache_key).and_return(incomplete_cache)
        allow(Rails.cache).to receive(:write)

        expect(subject.call).to eq(service_response)
        expect(ServiceResponse).to have_received(:new).with(payload: 'Rephrased content', errors: nil)
        expect(Rails.cache).to have_received(:write).with(cache_key, { data: { 2 => 'other rephrased content', index => 'Rephrased content' }, cached_at: anything })
      end
    end

    context 'when caching is disabled' do
      subject { described_class.new(chapter: chapter, target_language: target_language, index: index, original: original, translated: translated, cached: false, model: model) }

      it 'always generates a new response' do
        expect(Rails.cache).not_to receive(:fetch)
        expect(subject.call).to eq(service_response)
        expect(ServiceResponse).to have_received(:new).with(payload: 'Rephrased content', errors: nil)
      end
    end
  end
end
