class ConversationEventForm
  include ActiveModel::Model

  attr_accessor :author, :content, :project_status, :event_type

  validates :author, presence: true
  validates :event_type, inclusion: { in: %w[Comment StatusChange] }
  validates :content, presence: true, if: :comment?
  validates :project_status,
           inclusion: { in: ConversationEvent::VALID_STATUSES },
           presence: true,
           if: :status_change?

  def save
    return false unless valid?

    event_class.create!(attributes_for_save)
  end

  private

  def comment?
    event_type == "Comment"
  end

  def status_change?
    event_type == "StatusChange"
  end

  def event_class
    event_type.constantize
  end

  def attributes_for_save
    if comment?
      { author: author, content: content }
    else
      { author: author, project_status: project_status }
    end
  end
end
