class ConversationEvent < ApplicationRecord
  # Constants
  VALID_STATUSES = %w[Draft In\ Review Approved Rejected].freeze
  EVENTS_PER_PAGE = 10

  # Validations
  validates :author, presence: true
  validates :type, presence: true

  # Scopes
  scope :chronological, -> { order(created_at: :desc) }

  # Class Methods
  def self.paginate(page:)
    page = [ page.to_i, 1 ].max
    offset = (page - 1) * EVENTS_PER_PAGE
    chronological.limit(EVENTS_PER_PAGE).offset(offset)
  end

  def self.total_pages
    count = self.count
    return 1 if count.zero?
    (count.to_f / EVENTS_PER_PAGE).ceil
  end

  # Instance Methods
  def status_change?
    type == "StatusChange"
  end
end
