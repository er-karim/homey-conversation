FactoryBot.define do
  factory :conversation_event do
    author { Faker::Name.name }

    factory :comment do
      type { 'Comment' }
      content { Faker::Lorem.paragraph }
    end

    factory :status_change do
      type { 'StatusChange' }
      project_status { ConversationEvent::VALID_STATUSES.sample }
    end
  end
end
