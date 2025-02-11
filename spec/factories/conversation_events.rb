FactoryBot.define do
  factory :conversation_event do
    author { Faker::Name.name }

    factory :comment do
      type { 'Comment' }
      content { Faker::Lorem.paragraph(sentence_count: 2, supplemental: true, random_sentences_to_add: 3) }
    end

    factory :status_change do
      type { 'StatusChange' }
      project_status { ConversationEvent::VALID_STATUSES.sample }

      after(:create) do |status_change|
        status_change.update_column(:content, "Status changed to #{status_change.project_status}")
      end
    end

    trait :old_record do
      created_at { Faker::Time.between(from: 30.days.ago, to: 10.days.ago) }
    end

    trait :recent_record do
      created_at { Faker::Time.between(from: 9.days.ago, to: Time.current) }
    end
  end
end
