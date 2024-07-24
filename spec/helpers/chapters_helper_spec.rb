require 'rails_helper'

RSpec.describe Writer::ChaptersHelper, type: :helper do
  describe '#current_translate' do
    before do
      allow(helper).to receive(:params).and_return(translate_code: 'en')
    end

    it 'returns the translate_code from params' do
      expect(helper.current_translate).to eq('en')
    end
  end

  describe '#page_settings' do
    it 'returns the correct font size settings' do
      expect(helper.page_settings[:font_size]).to eq(
        {
          list: [10, 11, 12, 13, 14, 15, 16, 17, 18, 20, 22, 24, 26, 28, 32],
          default: 13
        }
      )
    end

    it 'returns the correct paragraph space settings' do
      expect(helper.page_settings[:p_space]).to eq(
        {
          min: 10,
          max: 40,
          default: 16
        }
      )
    end

    it 'returns the correct translation settings' do
      expect(helper.page_settings[:translation]).to eq(
        {
          list: [[true, 'block'], [false, 'none']],
          default: true
        }
      )
    end
  end

  describe '#empty_str?' do
    it 'returns true for an empty string with only HTML tags and whitespace' do
      expect(helper.empty_str?('<div>&nbsp;&nbsp;</div>')).to be_truthy
    end

    it 'returns true for a string with only whitespace' do
      expect(helper.empty_str?('    ')).to be_truthy
    end

    it 'returns false for a non-empty string' do
      expect(helper.empty_str?('Hello world!')).to be_falsey
    end

    it 'returns true for a string with HTML tags but no visible content' do
      expect(helper.empty_str?('<p> </p>')).to be_truthy
    end
  end

  describe '#published_class' do
    let(:published_chapter) { create(:chapter, published: true) }
    let(:unpublished_chapter) { create(:chapter) }

    it 'returns "next-btn" when the chapter is published' do
      expect(helper.published_class(published_chapter)).to eq('next-btn')
    end

    it 'returns "save-btn" when the chapter is not published' do
      expect(helper.published_class(unpublished_chapter)).to eq('save-btn')
    end
  end
end
