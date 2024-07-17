# spec/models/comment_spec.rb
require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'associations' do
    it { should belong_to(:commenter).class_name('User') }
    it { should belong_to(:chapter) }
  end

  describe 'validations' do
    it { should validate_presence_of(:comment) }
    it { should validate_presence_of(:commenter) }
    it { should validate_presence_of(:chapter) }
    it { should validate_presence_of(:paragraph_id) }
  end

  describe 'callbacks' do
    let!(:story) { create(:story) }
    let!(:chapter) { create(:chapter, story: story, published: true) }
    let!(:commenter) { create(:user) }
    let!(:comment) { create(:comment, chapter: chapter, commenter: commenter, paragraph_id: 1) }

    it 'triggers broadcast_destroy_comment after destroy' do
      expect(comment).to receive(:broadcast_destroy_comment)
      comment.destroy
    end
  end
end
