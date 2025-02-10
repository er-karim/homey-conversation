require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:content) }
  end

  describe 'inheritance' do
    it 'inherits from ConversationEvent' do
      expect(described_class.superclass).to eq(ConversationEvent)
    end
  end
end
