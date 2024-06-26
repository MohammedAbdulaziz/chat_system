class UpdateCountsJob < ApplicationJob
  queue_as :default

  def perform
    puts "Updating counts..."
    Application.find_each do |application|
      application.update(chats_count: application.chats.count)
    end

    Chat.find_each do |chat|
      chat.update(messages_count: chat.messages.count)
    end
  end
end
