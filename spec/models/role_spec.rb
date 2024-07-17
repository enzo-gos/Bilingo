require 'rails_helper'

RSpec.describe Role, type: :model do
  describe 'associations' do
    it { should have_and_belong_to_many(:users).join_table(:users_roles) }
    it { should belong_to(:resource).optional }
  end

  describe 'validations' do
    it { should validate_inclusion_of(:resource_type).in_array(Rolify.resource_types).allow_nil }
    it { should validate_presence_of(:name) }
    it { should validate_inclusion_of(:name).in_array(Role::NAMES) }
  end

  describe 'constants' do
    it 'defines a constant NAMES with the expected values' do
      expect(Role::NAMES).to eq(%w[admin user])
    end
  end
end
