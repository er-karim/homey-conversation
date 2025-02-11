class ConversationEventsController < ApplicationController
  def index
    @page = params[:page] || 1
    @events = ConversationEvent.paginate(page: @page)
    @total_pages = ConversationEvent.total_pages
    @comment_form = ConversationEventForm.new(event_type: "Comment")
    @status_form = ConversationEventForm.new(event_type: "StatusChange")
  end

  def create
    form = ConversationEventForm.new(conversation_event_params)
    result = form.save

    respond_to do |format|
      if result.success?
        flash_message = {
          form_type: conversation_event_params[:event_type].downcase,
          text: "Event created successfully"
        }

        format.turbo_stream do
          streams = []
          @events = ConversationEvent.paginate(page: 1)
          @total_pages = ConversationEvent.total_pages

          streams << turbo_stream.update("conversation_events",
            render_to_string(partial: "conversation_events/list",
                          locals: { events: @events,
                                  current_page: 1,
                                  total_pages: @total_pages }))

          streams << turbo_stream.replace("flash_messages",
            render_to_string(partial: "shared/flash_messages",
                          locals: { flash: { success: flash_message } }))

          render turbo_stream: streams
        end
      else
        error_message = {
          form_type: conversation_event_params[:event_type].downcase,
          text: result.errors.full_messages.join(", ")
        }

        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("flash_messages",
                              partial: "shared/flash_messages",
                              locals: { flash: { error: error_message } })
          ]
        end
      end
    end
  end

  private

  def conversation_event_params
    params.require(:conversation_event)
          .permit(:event_type, :author, :content, :project_status)
  end
end
