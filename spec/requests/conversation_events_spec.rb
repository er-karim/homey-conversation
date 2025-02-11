require 'rails_helper'

RSpec.describe "ConversationEvents", type: :request do
  describe "GET /conversation_events" do
    context "when there are events" do
      before do
        create_list(:comment, 15)
      end

      it "returns the first page of events by default" do
        get conversation_events_path
        expect(response).to have_http_status(:success)
        expect(assigns(:events).count).to eq(10)
        expect(assigns(:page)).to eq(1)
      end

      it "returns the requested page of events" do
        get conversation_events_path(page: 2)
        expect(response).to have_http_status(:success)
        expect(assigns(:events).count).to eq(5)
        expect(assigns(:page)).to eq("2")
      end

      it "initializes form objects" do
        get conversation_events_path
        expect(assigns(:comment_form)).to be_a(ConversationEventForm)
        expect(assigns(:comment_form).event_type).to eq("Comment")
        expect(assigns(:status_form)).to be_a(ConversationEventForm)
        expect(assigns(:status_form).event_type).to eq("StatusChange")
      end
    end

    context "when there are no events" do
      it "returns an empty collection" do
        get conversation_events_path
        expect(response).to have_http_status(:success)
        expect(assigns(:events)).to be_empty
        expect(assigns(:total_pages)).to eq(1)
      end
    end
  end

  describe "POST /conversation_events" do
    context "with turbo stream format" do
      context "when creating a comment" do
        let(:valid_params) do
          {
            conversation_event: {
              event_type: 'Comment',
              author: 'John Doe',
              content: 'Test comment'
            }
          }
        end

        let(:invalid_params) do
          {
            conversation_event: {
              event_type: 'Comment',
              author: '',
              content: ''
            }
          }
        end

        context "with valid params" do
          it "creates a new comment and returns success turbo stream" do
            expect {
              post conversation_events_path,
                   params: valid_params,
                   headers: { 'Accept': 'text/vnd.turbo-stream.html' }
            }.to change(Comment, :count).by(1)

            expect(response).to have_http_status(:success)
            expect(response.media_type).to eq Mime[:turbo_stream]
            expect(response.body).to include('conversation_events')
            expect(response.body).to include('flash_messages')
            expect(response.body).to include('comment')
            expect(response.body).to include('Event created successfully')
          end
        end

        context "with invalid params" do
          it "returns error turbo stream with validation messages" do
            expect {
              post conversation_events_path,
                   params: invalid_params,
                   headers: { 'Accept': 'text/vnd.turbo-stream.html' }
            }.not_to change(Comment, :count)

            expect(response).to have_http_status(:success)
            expect(response.media_type).to eq Mime[:turbo_stream]
            expect(response.body).to include('flash_messages')
            expect(response.body).to include(ConversationEventForm::ERRORS[:author_blank])
            expect(response.body).to include(ConversationEventForm::ERRORS[:content_blank])
          end
        end
      end

      context "when creating a status change" do
        let(:valid_params) do
          {
            conversation_event: {
              event_type: 'StatusChange',
              author: 'John Doe',
              project_status: 'In Review'
            }
          }
        end

        let(:invalid_params) do
          {
            conversation_event: {
              event_type: 'StatusChange',
              author: '',
              project_status: ''
            }
          }
        end

        context "with valid params" do
          it "returns error turbo stream with validation messages" do
            expect {
              post conversation_events_path,
                  params: invalid_params,
                  headers: { 'Accept': 'text/vnd.turbo-stream.html' }
            }.not_to change(StatusChange, :count)

            expect(response).to have_http_status(:success)
            expect(response.media_type).to eq Mime[:turbo_stream]
            expect(response.body).to include('Statuschange:')
            expect(response.body).to include('Please provide your name')
            expect(response.body).to include('Please select a status')
          end
        end

        context "with invalid params" do
          it "returns error turbo stream with validation messages" do
            expect {
              post conversation_events_path,
                   params: invalid_params,
                   headers: { 'Accept': 'text/vnd.turbo-stream.html' }
            }.not_to change(StatusChange, :count)

            expect(response).to have_http_status(:success)
            expect(response.media_type).to eq Mime[:turbo_stream]
            expect(response.body).to include('flash_messages')
            expect(response.body).to include(ConversationEventForm::ERRORS[:author_blank])
            expect(response.body).to include(ConversationEventForm::ERRORS[:status_blank])
          end
        end
      end
    end
  end
end
