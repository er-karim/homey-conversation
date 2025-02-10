class Comment < ConversationEvent
  # Validations
  validates :content, presence: true
end
