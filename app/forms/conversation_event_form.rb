class ConversationEventForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :author, :string
  attribute :content, :string
  attribute :project_status, :string
  attribute :event_type, :string

  ERRORS = {
    author_blank: "Please provide your name",
    content_blank: "Comment cannot be empty",
    status_blank: "Please select a status",
    invalid_status: "Please select a valid status"
  }.freeze

  validates :author, presence: { message: ERRORS[:author_blank] }
  validates :event_type, inclusion: { in: %w[Comment StatusChange] }
  validates :content, presence: { message: ERRORS[:content_blank] }, if: :comment?
  validates :project_status,
           presence: { message: ERRORS[:status_blank] },
           inclusion: { in: ConversationEvent::VALID_STATUSES,
                       message: ERRORS[:invalid_status],
                       allow_blank: true },
           if: :status_change?

  def save
    return ServiceResult.new(success: false, errors: errors) unless valid?

    ActiveRecord::Base.transaction do
      event = event_class.create!(attributes_for_save)
      ServiceResult.new(success: true, data: event)
    end
  rescue ActiveRecord::RecordInvalid => e
    errors.merge!(e.record.errors)
    ServiceResult.new(success: false, errors: errors)
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
