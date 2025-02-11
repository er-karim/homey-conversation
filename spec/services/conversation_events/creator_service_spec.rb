require 'rails_helper'

RSpec.describe ConversationEvents::CreatorService do
  describe '#call' do
    context 'with valid params' do
      context 'for comments' do
        let(:valid_params) do
          {
            event_type: 'Comment',
            author: 'John Doe',
            content: 'Test comment'
          }
        end

        it 'creates a new comment' do
          service = described_class.new(valid_params)
          expect { service.call }.to change(Comment, :count).by(1)
        end

        it 'returns a successful result' do
          result = described_class.new(valid_params).call

          expect(result).to be_success
          expect(result.data).to be_a(Comment)
          expect(result.data).to have_attributes(
            author: 'John Doe',
            content: 'Test comment'
          )
        end
      end

      context 'for status changes' do
        let(:valid_params) do
          {
            event_type: 'StatusChange',
            author: 'John Doe',
            project_status: 'In Review'
          }
        end

        it 'creates a new status change' do
          service = described_class.new(valid_params)
          expect { service.call }.to change(StatusChange, :count).by(1)
        end

        it 'returns a successful result' do
          result = described_class.new(valid_params).call

          expect(result).to be_success
          expect(result.data).to be_a(StatusChange)
          expect(result.data).to have_attributes(
            author: 'John Doe',
            project_status: 'In Review'
          )
        end
      end
    end

    context 'with invalid params' do
      context 'for comments' do
        let(:invalid_params) do
          {
            event_type: 'Comment',
            author: '',
            content: ''
          }
        end

        it 'does not create a comment' do
          service = described_class.new(invalid_params)
          expect { service.call }.not_to change(Comment, :count)
        end

        it 'returns a failure result with errors' do
          result = described_class.new(invalid_params).call

          expect(result).not_to be_success
          expect(result.errors).to be_present
          expect(result.errors.messages.keys).to match_array([ :author, :content ])
        end
      end

      context 'for status changes' do
        let(:invalid_params) do
          {
            event_type: 'StatusChange',
            author: '',
            project_status: 'Invalid'
          }
        end

        it 'does not create a status change' do
          service = described_class.new(invalid_params)
          expect { service.call }.not_to change(StatusChange, :count)
        end

        it 'returns a failure result with errors' do
          result = described_class.new(invalid_params).call

          expect(result).not_to be_success
          expect(result.errors).to be_present
          expect(result.errors.messages.keys).to match_array([ :author, :project_status ])
        end
      end
    end

    context 'when an unexpected error occurs' do
      let(:valid_params) do
        {
          event_type: 'Comment',
          author: 'John Doe',
          content: 'Test comment'
        }
      end

      it 'handles the error and returns a failure result' do
        service = described_class.new(valid_params)
        allow(service).to receive(:create_event).and_raise(StandardError)

        result = service.call
        expect(result).not_to be_success
        expect(result.errors).to eq([ "An unexpected error occurred" ])
      end

      it 'does not create a record' do
        service = described_class.new(valid_params)
        allow(service).to receive(:create_event).and_raise(StandardError)

        expect { service.call }.not_to change(Comment, :count)
      end
    end
  end
end
