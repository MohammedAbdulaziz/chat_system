class CreateMessageWorker
  include Sneakers::Worker
  from_queue 'create_message', ack: true

  def work(msg)
    data = JSON.parse(msg)
    chat_id = data['chat_id']

    chat = Chat.find(chat_id)
    message_number = $redis.get("max_message_number:#{chat.id}").to_i
    $redis.set("max_message_number:#{chat.id}", message_number)

    body = data['body']
    Message.create!(chat: chat, number: message_number, body: body)
    ack!
  rescue => e
    Sneakers.logger.error "Failed to create message: #{e.message}"
    reject!
  end
end
