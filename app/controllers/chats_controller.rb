class ChatsController < ApplicationController
  before_action :set_application
  before_action :set_chat, only: [:update, :show]

  def create
    chat_number = $redis.incr("max_chat_number:#{@application.token}")

    msg = { application_id: @application.id, chat_number: chat_number }.to_json
    RABBITMQ_CHANNEL.default_exchange.publish(msg, routing_key: 'create_chat')

    render json: { status: 'Chat creation in progress', number: chat_number }, status: :accepted
  end

  def update
    if @chat.update(chat_params)
      render json: @chat.as_json
    else
      render json: @chat.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @chat.as_json
  end

  private

  def set_application
    @application = Application.find_by(token: params[:application_application_token])
    render json: { error: 'Application not found' }, status: :not_found unless @application
  end

  def set_chat
    @chat = @application.chats.find_by(number: params[:chat_number])
    render json: { error: 'Chat not found' }, status: :not_found unless @chat
  end

  def chat_params
    params.require(:chat).permit(:number)
  end
end
