require 'factory_bot_rails'

puts 'Cleaning database...'
ConversationEvent.delete_all

puts 'Creating old records...'
10.times do |i|
  FactoryBot.create(:comment, :old_record)
  FactoryBot.create(:status_change, :old_record)
  puts "Created old records #{i + 1}/10"
end

puts 'Creating recent records...'
10.times do |i|
  FactoryBot.create(:comment, :recent_record)
  FactoryBot.create(:status_change, :recent_record)
  puts "Created recent records #{i + 1}/10"
end

total_records = ConversationEvent.count
puts "Seeds completed successfully! Created #{total_records} records."
puts "Comments: #{Comment.count}"
puts "Status Changes: #{StatusChange.count}"
