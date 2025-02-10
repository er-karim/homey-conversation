class StatusChange < ConversationEvent
  # Validations
  validates :project_status, presence: true

  # Callbacks
  before_save :set_content

  private

  def set_content
    self.content = "Changed status to #{project_status}"
  end
end
