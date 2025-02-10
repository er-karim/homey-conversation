require 'rails_helper'

RSpec.describe StatusChange, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:project_status) }
    it { should validate_inclusion_of(:project_status).in_array(ConversationEvent::VALID_STATUSES) }
  end

  describe 'callbacks' do
    it 'sets content before save' do
      status_change = create(:status_change, project_status: 'Approved')
      expect(status_change.content).to eq('Changed status to Approved')
    end
  end

  describe 'inheritance' do
    it 'inherits from ConversationEvent' do
      expect(described_class.superclass).to eq(ConversationEvent)
    end
  end
end
