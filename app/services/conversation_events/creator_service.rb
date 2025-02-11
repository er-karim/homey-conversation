module ConversationEvents
  class CreatorService
    def initialize(params)
      @form = ConversationEventForm.new(params)
    end

    def call
      return ServiceResult.new(success: false, errors: form.errors) unless form.valid?

      ActiveRecord::Base.transaction do
        event = create_event
        ServiceResult.new(success: true, data: event)
      end
    rescue StandardError => e
      ServiceResult.new(success: false, errors: [ "An unexpected error occurred" ])
    end

    private

    attr_reader :form

    def create_event
      klass = form.event_type.constantize
      event = klass.new(
        author: form.author,
        content: form.content,
        project_status: form.project_status
      )
      event.save!
      event
    end
  end
end
