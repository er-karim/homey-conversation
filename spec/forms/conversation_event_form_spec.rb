require 'rails_helper'

RSpec.describe ConversationEventForm do
  describe 'validations' do
    context 'common validations' do
      it { is_expected.to validate_presence_of(:author) }
      it { is_expected.to validate_inclusion_of(:event_type).in_array(%w[Comment StatusChange]) }
    end

    context 'when event_type is Comment' do
      subject { described_class.new(event_type: 'Comment') }

      it { is_expected.to validate_presence_of(:content) }
      it { is_expected.not_to validate_presence_of(:project_status) }
    end

    context 'when event_type is StatusChange' do
      subject { described_class.new(event_type: 'StatusChange') }

      it { is_expected.to validate_presence_of(:project_status) }
      it { is_expected.to validate_inclusion_of(:project_status).in_array(ConversationEvent::VALID_STATUSES) }
      it { is_expected.not_to validate_presence_of(:content) }
    end
  end

  describe '#save' do
    context 'when creating a comment' do
      let(:form) do
        described_class.new(
          event_type: 'Comment',
          author: 'John Doe',
          content: 'Test comment'
        )
      end

      it 'creates a new comment' do
        expect { form.save }.to change(Comment, :count).by(1)
      end

      it 'sets the correct attributes' do
        comment = form.save
        expect(comment).to have_attributes(
          author: 'John Doe',
          content: 'Test comment',
          type: 'Comment'
        )
      end
    end

    context 'when creating a status change' do
      let(:form) do
        described_class.new(
          event_type: 'StatusChange',
          author: 'John Doe',
          project_status: 'Approved'
        )
      end

      it 'creates a new status change' do
        expect { form.save }.to change(StatusChange, :count).by(1)
      end

      it 'sets the correct attributes' do
        status_change = form.save
        expect(status_change).to have_attributes(
          author: 'John Doe',
          project_status: 'Approved',
          type: 'StatusChange'
        )
      end
    end

    context 'with invalid data' do
      let(:form) do
        described_class.new(
          event_type: 'Comment',
          author: '',
          content: ''
        )
      end

      it 'returns false' do
        expect(form.save).to be false
      end

      it 'does not create a new event' do
        expect { form.save }.not_to change(ConversationEvent, :count)
      end
    end
  end
end
