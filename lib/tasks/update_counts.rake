namespace :counts do
  desc "Update counts for applications and chats"
  task update: :environment do
    begin
      Application.find_each do |application|
        application.update(chats_count: application.chats.count)
      end

      Chat.find_each do |chat|
        chat.update(messages_count: chat.messages.count)
      end

    rescue StandardError => e
      Rails.logger.error "Error in counts:update task: #{e.message}"
    end
  end
end

