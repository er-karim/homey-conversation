class StatusChange < ConversationEvent
  # Validations
  validates :project_status, presence: true
  validates :project_status, inclusion: { in: VALID_STATUSES }

  # Callbacks
  before_save :set_content

  private

  def set_content
    self.content = "Status changed to #{project_status}"
  end
end
