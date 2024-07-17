# spec/services/story_service/creator_spec.rb
require 'rails_helper'

RSpec.describe StoryService::Creator do
  let(:author) { create(:user) }
  let(:primary_genre) { create(:genre) }
  let(:valid_params) { attributes_for(:story).merge(tag_list: '[{ "value": "tag1" }, { "value": "tag2" }]', primary_genre_id: primary_genre.id) }
  let(:invalid_params) { attributes_for(:story, name: nil).merge(tag_list: '[{ "value": "tag1" }, { "value": "tag2" }]') }

  describe '.call' do
    context 'with valid parameters' do
      it 'creates a new story' do
        expect { StoryService::Creator.call(params: valid_params, author: author) }.to change(Story, :count).by(1)
      end

      it 'creates the first chapter' do
        expect { StoryService::Creator.call(params: valid_params, author: author) }.to change(Chapter, :count).by(1)
      end

      it 'returns a successful ServiceResponse' do
        result = StoryService::Creator.call(params: valid_params, author: author)

        expect(result).to be_a(ServiceResponse)
        expect(result).to be_success
        expect(result.errors).to be_empty
        expect(result.payload[:story]).to be_a(Story)
        expect(result.payload[:chapter]).to be_a(Chapter)
      end

      it 'sets the correct author' do
        result = StoryService::Creator.call(params: valid_params, author: author)
        expect(result.payload[:story].author).to eq(author)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new story' do
        expect { StoryService::Creator.call(params: invalid_params, author: author) }.not_to change(Story, :count)
      end

      it 'does not create a chapter' do
        expect { StoryService::Creator.call(params: invalid_params, author: author) }.not_to change(Chapter, :count)
      end

      it 'returns a failed ServiceResponse with errors' do
        result = StoryService::Creator.call(params: invalid_params, author: author)

        expect(result).to be_a(ServiceResponse)
        expect(result).to be_fail
        expect(result.errors).not_to be_empty
        expect(result.payload[:story]).to be_a(Story)
        expect(result.payload[:chapter]).to be_nil
      end
    end
  end
end
