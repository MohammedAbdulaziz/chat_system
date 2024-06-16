class CreateChatWorker
  include Sneakers::Worker
  from_queue 'create_chat', ack: true

  def work(msg)
    data = JSON.parse(msg)
    application_id = data['application_id']

    application = Application.find(application_id)
    chat_number = $redis.get("max_chat_number:#{application.token}").to_i
    $redis.set("max_chat_number:#{application.token}", chat_number)

    Chat.create!(application: application, number: chat_number)
    ack!
  rescue => e
    Sneakers.logger.error "Failed to create chat: #{e.message}"
    reject!
  end
end
