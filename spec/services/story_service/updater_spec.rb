require 'rails_helper'

RSpec.describe StoryService::Updater, type: :service do
  describe '.call' do
    let(:story) { create(:story) }
    let(:valid_params) { { name: 'Updated Name' } }

    shared_examples 'invalid params' do |invalid_params|
      it 'does not update the story and returns errors' do
        response = StoryService::Updater.call(params: invalid_params, story: story)
        expect(response).to be_a(ServiceResponse)
        expect(response).to be_fail
        expect(response.errors).not_to be_empty
      end
    end

    context 'with valid params' do
      it 'updates the story' do
        response = StoryService::Updater.call(params: valid_params, story: story)
        expect(response.errors).to be_empty
      end
    end

    context 'with invalid params' do
      it_behaves_like 'invalid params', { name: nil }
      it_behaves_like 'invalid params', { cover_image: nil }
      it_behaves_like 'invalid params', { primary_genre: nil }
      it_behaves_like 'invalid params', { tag_list: '' }
    end
  end
end
