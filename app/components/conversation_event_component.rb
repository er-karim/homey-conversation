class ConversationEventComponent < ViewComponent::Base
  include IconHelper

  def initialize(conversation_event:)
    @event = conversation_event
  end

  private

  attr_reader :event

  def event_class
    case event
    when Comment
      "bg-blue-50"
    when StatusChange
      "bg-green-50"
    end
  end
end
