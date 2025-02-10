class CreateConversationEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :conversation_events do |t|
      t.string :type
      t.string :author
      t.text :content
      t.string :project_status

      t.timestamps
    end
  end
end
