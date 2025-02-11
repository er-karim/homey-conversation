require 'rails_helper'

RSpec.describe StatusChange, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:project_status) }
    it { is_expected.to validate_presence_of(:author) }
    it { is_expected.to validate_inclusion_of(:project_status).in_array(ConversationEvent::VALID_STATUSES) }
  end

  describe 'callbacks' do
    it 'sets content on save' do
      status_change = create(:status_change, project_status: 'In Review')
      expect(status_change.content).to eq('Status changed to In Review')
    end
  end

  describe 'inheritance' do
    it 'inherits from ConversationEvent' do
      expect(described_class.superclass).to eq(ConversationEvent)
    end
  end

  describe '#status_change?' do
    it 'returns true' do
      expect(build(:status_change).status_change?).to be true
    end
  end
end
