require 'bunny'

def establish_connection
  connection = Bunny.new(
    hostname: 'rabbitmq',
    vhost: '/',
    user: 'guest',
    password: 'guest',
    automatically_recover: false,
  )
  connection.start
  connection
end

begin
  RABBITMQ_CONN = establish_connection
  RABBITMQ_CHANNEL = RABBITMQ_CONN.create_channel
end
