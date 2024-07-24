# spec/helpers/application_helper_spec.rb
require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  let(:story) { create(:story, :with_cover_image) }
  let(:genre) { create(:genre) }

  describe '#all_genres' do
    it 'returns all genres' do
      create_list(:genre, 3)
      expect(helper.all_genres.count).to eq(Genre.count)
    end
  end

  describe '#current_locale' do
    it 'returns the current locale' do
      expect(helper.current_locale).to eq(I18n.locale)
    end
  end

  describe '#format_notification' do
    it 'formats notification count correctly' do
      expect(helper.format_notification(5)).to eq('5')
      expect(helper.format_notification(100)).to eq('99+')
    end
  end
end
