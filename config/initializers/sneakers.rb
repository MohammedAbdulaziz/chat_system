require 'sneakers'

Sneakers.configure(
  connection: Bunny.new(hostname: 'rabbitmq'),
  workers: 2
)
Sneakers.logger.level = Logger::INFO
