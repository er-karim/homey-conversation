class ConversationEvent < ApplicationRecord
  # Constants
  VALID_STATUSES = %w[Draft In\ Review Approved Rejected].freeze

  # Validations
  validates :author, presence: true
  validates :type, presence: true
  validates :project_status, inclusion: { in: VALID_STATUSES }, if: :status_change?

  # Scopes
  scope :chronological, -> { order(created_at: :desc) }

  # Instance Methods
  def status_change?
    type == "StatusChange"
  end
end
