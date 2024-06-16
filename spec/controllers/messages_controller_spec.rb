require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  let!(:application) { create(:application) }
  let!(:chat) { create(:chat, application: application) }
  let(:valid_attributes) { { body: "This is a message" } }

  before do
    allow($redis).to receive(:incr).and_return(1)
    allow(RABBITMQ_CHANNEL.default_exchange).to receive(:publish)
  end

  describe "POST #create" do
    it "creates a new Message" do
      expect {
        post :create, params: { application_application_token: application.token, chat_chat_number: chat.number, message: valid_attributes }
      }.to change(Message, :count).by(0)
    end

    it "renders a JSON response with the message number" do
      post :create, params: { application_application_token: application.token, chat_chat_number: chat.number, message: valid_attributes }
      expect(response).to have_http_status(:accepted)
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end
  end

  describe "GET #show" do
    let!(:message) { create(:message, chat: chat) }

    context "when message exists" do
      it "returns the message" do
        get :show, params: { application_application_token: application.token, chat_chat_number: chat.number, message_number: message.number }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context "when message does not exist" do
      it "returns a not found status" do
        get :show, params: { application_application_token: application.token, chat_chat_number: chat.number, message_number: 999 }
        expect(response).to have_http_status(:not_found)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe "GET #search" do
    it "returns search results" do
      get :search, params: { application_application_token: application.token, chat_chat_number: chat.number, query: "message" }
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end
  end
end
