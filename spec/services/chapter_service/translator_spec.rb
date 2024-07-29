require 'rails_helper'

RSpec.describe ChapterService::Translator do
  let(:chapter) { create(:chapter) }
  let(:source_language) { 'en' }
  let(:target_language) { 'es' }
  let(:translate_client) { instance_double('Google::Cloud::Translate::V3::TranslationService') }
  let(:translated_title) { Faker::Lorem.sentence }
  let(:translated_content) { [Faker::Lorem.sentence, Faker::Lorem.sentence] }

  before do
    allow(Google::Cloud::Translate).to receive(:translation_service).and_return(translate_client)
    allow(translate_client).to receive(:translate_text).and_return(
      double(translations: [double(translated_text: translated_title)]),
      double(translations: translated_content.map { |text| double(translated_text: text) })
    )
  end

  describe '.call' do
    it 'calls the instance method' do
      expect_any_instance_of(described_class).to receive(:call)

      described_class.call(chapter: chapter, source_language: source_language, target_language: target_language)
    end
  end

  describe '#call' do
    subject { described_class.new(chapter: chapter, source_language: source_language, target_language: target_language) }

    context 'when translation is needed' do
      it 'returns translated content' do
        result = subject.call

        expect(result[:show_translate]).to be true
        expect(result[:translated][:content]).to be_a(Hash)
        expect(result[:translated][:content].values).to all(be_a(String))
      end
    end

    context 'when caching is involved' do
      let(:cache_key) { "translate_#{target_language}_#{chapter.id}" }
      let(:cached_translation) do
        {
          title: Faker::Book.title,
          content: { '1' => Faker::Lorem.sentence, '2' => Faker::Lorem.sentence },
          cached_at: Time.now
        }
      end

      it 'uses cached translation if available and not outdated' do
        allow(Rails.cache).to receive(:fetch).with(cache_key).and_return(cached_translation)

        result = subject.call

        expect(result[:translated]).to eq(cached_translation)
        expect(Rails.cache).to have_received(:fetch).with(cache_key)
      end

      it 'does not use cached translation if outdated' do
        outdated_cache = cached_translation.merge(cached_at: 1.day.ago)
        allow(Rails.cache).to receive(:fetch).with(cache_key).and_return(outdated_cache)
        allow(Rails.cache).to receive(:write)

        subject.call

        expect(Rails.cache).to have_received(:fetch).with(cache_key)
        expect(Rails.cache).to have_received(:write).with(cache_key, anything)
      end
    end

    context 'when Google::Cloud::InvalidArgumentError is raised' do
      before do
        stub_const('Google::Cloud::InvalidArgumentError', Class.new(StandardError))
        allow(translate_client).to receive(:translate_text).and_raise(Google::Cloud::InvalidArgumentError)
      end

      it 'handles the error and returns no translation' do
        result = subject.call

        expect(result[:show_translate]).to be false
        expect(result[:translated]).to be_nil
      end
    end
  end
end
