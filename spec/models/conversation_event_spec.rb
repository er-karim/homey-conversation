require 'rails_helper'

RSpec.describe ConversationEvent, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:author) }
    it { should validate_presence_of(:type) }
  end

  describe 'scopes' do
    describe '.chronological' do
      it 'orders events by created_at in descending order' do
        old_event = create(:comment, created_at: 2.days.ago)
        new_event = create(:comment, created_at: 1.day.ago)

        expect(described_class.chronological).to eq([ new_event, old_event ])
      end
    end
  end
end
