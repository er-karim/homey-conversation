require 'rails_helper'

RSpec.describe ConversationEvent, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:author) }
    it { should validate_presence_of(:type) }

    context 'when type is StatusChange' do
      subject { StatusChange.new }

      it { should validate_inclusion_of(:project_status).in_array(described_class::VALID_STATUSES) }
    end
  end

  describe 'scopes' do
    describe '.chronological' do
      it 'orders events by created_at in descending order' do
        old_event = create(:comment, created_at: 2.days.ago)
        new_event = create(:comment, created_at: 1.day.ago)

        events = described_class.chronological
        expect(events.map(&:id)).to eq([ new_event.id, old_event.id ])
        expect(events.map(&:created_at)).to eq([ new_event.created_at, old_event.created_at ])
      end
    end
  end

  describe '.paginate' do
    before { create_list(:comment, 12) }

    it 'returns the specified page of events' do
      expect(described_class.paginate(page: 1).count).to eq(10)
      expect(described_class.paginate(page: 2).count).to eq(2)
    end

    it 'returns first page for invalid page numbers' do
      expect(described_class.paginate(page: 0).count).to eq(10)
      expect(described_class.paginate(page: -1).count).to eq(10)
    end
  end

  describe '.total_pages' do
    it 'calculates total pages' do
      create_list(:comment, 21)
      expect(described_class.total_pages).to eq(3)
    end

    it 'returns 1 for empty table' do
      described_class.delete_all
      expect(described_class.total_pages).to eq(1)
    end
  end

  describe '#status_change?' do
    it 'returns true for StatusChange type' do
      event = build(:status_change)
      expect(event.type).to eq('StatusChange')
      expect(event.status_change?).to be true
    end

    it 'returns false for Comment type' do
      event = build(:comment)
      expect(event.type).to eq('Comment')
      expect(event.status_change?).to be false
    end
  end
end
