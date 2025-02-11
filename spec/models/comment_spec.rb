require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_presence_of(:author) }
  end

  describe 'inheritance' do
    it 'inherits from ConversationEvent' do
      expect(described_class.superclass).to eq(ConversationEvent)
    end
  end

  describe '#status_change?' do
    it 'returns false' do
      expect(build(:comment).status_change?).to be false
    end
  end
end
