$redis = Redis.new(url: 'redis://redis:6379')

Rails.application.config.after_initialize do
  if ActiveRecord::Base.connection.data_source_exists?('applications')
    Application.find_each do |application|
      max_chat_number = application.chats.maximum(:number).to_i
      $redis.set("max_chat_number:#{application.token}", max_chat_number)
      
      application.chats.find_each do |chat|
        max_message_number = chat.messages.maximum(:number).to_i
        $redis.set("max_message_number:#{chat.id}", max_message_number)
      end
    end
  end
end