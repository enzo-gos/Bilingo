require 'rails_helper'

class ExampleNotifier < Noticed::Event
  deliver_by :test
  required_params :message
end

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'is not valid without a first name' do
      user = build(:user, first_name: nil)
      expect(user).not_to be_valid
    end

    it 'is not valid without a last name' do
      user = build(:user, last_name: nil)
      expect(user).not_to be_valid
    end
  end

  describe '#active_for_authentication?' do
    it 'returns true if the user is active' do
      user = build(:user, active: true)
      expect(user.active_for_authentication?).to be_truthy
    end

    it 'returns false if the user is not active' do
      user = build(:user, active: false)
      expect(user.active_for_authentication?).to be_falsey
    end
  end

  describe '#account_active?' do
    it 'returns true if the active attribute is true' do
      user = build(:user, active: true)
      expect(user.account_active?).to be_truthy
    end

    it 'returns false if the active attribute is false' do
      user = build(:user, active: false)
      expect(user.account_active?).to be_falsey
    end
  end

  describe '.from_omniauth' do
    let(:auth) do
      OmniAuth::AuthHash.new(
        provider: 'facebook',
        uid: '123456789',
        info: {
          email: Faker::Internet.email,
          name: 'Doe John',
          image: 'http://example.com/avatar.jpg'
        }
      )
    end

    it 'creates a new user if one does not exist' do
      expect { User.from_omniauth(auth) }.to change(User, :count).by(1)
    end

    it 'finds an existing user if one exists' do
      user = create(:user, email: auth.info.email)
      expect(User.from_omniauth(auth)).to eq(user)
    end

    it 'sets the user attributes correctly' do
      user = User.from_omniauth(auth)
      expect(user.provider).to eq('facebook')
      expect(user.uid).to eq('123456789')
      expect(user.first_name).to eq('John')
      expect(user.last_name).to eq('Doe')
      expect(user.avatar).to eq('http://example.com/avatar.jpg')
    end
  end

  describe '#fullname' do
    it 'returns the full name of the user' do
      user = build(:user, first_name: 'John', last_name: 'Doe')
      expect(user.fullname).to eq('John Doe')
    end
  end

  describe '#unread_notifications_count' do
    it 'returns the count of unread notifications' do
      user = create(:user)
      ExampleNotifier.with(message: 'Test Message').deliver(user)
      expect(user.unread_notifications_count).to eq(1)
    end
  end
end
