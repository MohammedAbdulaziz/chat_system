class Publisher
  def self.publish(queue, message)
    connection = Bunny.new
    connection.start

    channel = connection.create_channel
    queue = channel.queue(queue, durable: true)

    channel.default_exchange.publish(message, routing_key: queue.name)
    connection.close
  end
end
