# spec/forms/conversation_event_form_spec.rb
require 'rails_helper'

RSpec.describe ConversationEventForm do
  describe 'validations' do
    describe 'event type validation' do
      subject { described_class.new }

      it 'accepts valid event types' do
        form = described_class.new(event_type: 'Comment')
        form.valid?
        expect(form.errors[:event_type]).to be_empty

        form = described_class.new(event_type: 'StatusChange')
        form.valid?
        expect(form.errors[:event_type]).to be_empty
      end

      it 'rejects invalid event types' do
        form = described_class.new(event_type: 'Invalid')
        form.valid?
        expect(form.errors[:event_type]).to be_present
      end
    end

    context 'for comments' do
      subject { described_class.new(event_type: 'Comment') }

      it 'requires author' do
        subject.valid?
        expect(subject.errors[:author]).to include(ConversationEventForm::ERRORS[:author_blank])
      end

      it 'requires content' do
        subject.valid?
        expect(subject.errors[:content]).to include(ConversationEventForm::ERRORS[:content_blank])
      end

      it 'does not require project_status' do
        subject.valid?
        expect(subject.errors[:project_status]).to be_empty
      end
    end

    context 'for status changes' do
      subject { described_class.new(event_type: 'StatusChange') }

      it 'requires author' do
        subject.valid?
        expect(subject.errors[:author]).to include(ConversationEventForm::ERRORS[:author_blank])
      end

      it 'requires project_status' do
        subject.valid?
        expect(subject.errors[:project_status]).to include(ConversationEventForm::ERRORS[:status_blank])
      end

      it 'validates project_status inclusion' do
        subject.project_status = 'Invalid'
        subject.valid?
        expect(subject.errors[:project_status]).to include(ConversationEventForm::ERRORS[:invalid_status])
      end

      it 'does not require content' do
        subject.valid?
        expect(subject.errors[:content]).to be_empty
      end
    end
  end

  describe '#save' do
    context 'when record validation fails' do
      it 'handles ActiveRecord::RecordInvalid and returns errors' do
        form = described_class.new(
          event_type: 'Comment',
          author: 'John Doe',
          content: 'Test'
        )

        invalid_record = Comment.new
        invalid_record.errors.add(:base, "Some error")

        expect_any_instance_of(Comment).to(
          receive(:save!)
          .and_raise(ActiveRecord::RecordInvalid.new(invalid_record))
        )

        result = form.save
        expect(result).not_to be_success
        expect(result.errors).to be_present
        expect(result.errors[:base]).to include("Some error")
      end
    end

    describe '#attributes_for_save' do
      it 'returns correct attributes for Comment' do
        form = described_class.new(
          event_type: 'Comment',
          author: 'John Doe',
          content: 'Test content',
          project_status: 'Draft'  # Should be ignored
        )

        result = form.save
        expect(result.data.attributes.slice('author', 'content', 'project_status'))
          .to eq({
            'author' => 'John Doe',
            'content' => 'Test content',
            'project_status' => nil
          })
      end

      it 'returns correct attributes for StatusChange' do
        form = described_class.new(
          event_type: 'StatusChange',
          author: 'John Doe',
          content: 'Should be ignored',
          project_status: 'Draft'
        )

        result = form.save
        expect(result.data.attributes.slice('author', 'project_status'))
          .to eq({
            'author' => 'John Doe',
            'project_status' => 'Draft'
          })
      end
    end
  end
end
