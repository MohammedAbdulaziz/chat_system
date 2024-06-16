class MessagesController < ApplicationController
  before_action :set_application
  before_action :set_chat
  before_action :set_message, only: [:update, :show]

  def create
    message_number = $redis.incr("max_message_number:#{@chat.id}")

    msg = { chat_id: @chat.id, message_number: message_number, body: message_params[:body] }.to_json
    RABBITMQ_CHANNEL.default_exchange.publish(msg, routing_key: 'create_message')

    render json: { status: 'Message creation in progress', number: message_number }, status: :accepted
  end

  def update
    if @message.update(message_params)
      render json: @message.as_json
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @message.as_json
  end

  def search
    if @chat
      results = Message.search(params[:query], @chat.id)
      render json: results.as_json
    else
      render json: { error: 'Chat not found' }, status: :not_found
    end
  end

  private

  def set_application
    @application = Application.find_by(token: params[:application_application_token])
    render json: { error: 'Application not found' }, status: :not_found unless @application
  end

  def set_chat
    @chat = @application.chats.find_by(number: params[:chat_chat_number])
    render json: { error: 'Chat not found' }, status: :not_found unless @chat
  end

  def set_message
    @message = @chat.messages.find_by(number: params[:message_number])
    render json: { error: 'Message not found' }, status: :not_found unless @message
  end

  def message_params
    params.require(:message).permit(:body)
  end
end
