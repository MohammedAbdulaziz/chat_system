require 'rails_helper'

RSpec.describe ChatsController, type: :controller do
  let!(:application) { create(:application) }
  let(:valid_attributes) { { number: 1 } }

  before do
    allow($redis).to receive(:incr).and_return(1)
    allow(RABBITMQ_CHANNEL.default_exchange).to receive(:publish)
  end

  describe "POST #create" do
    it "creates a new Chat" do
      expect {
        post :create, params: { application_application_token: application.token, chat: valid_attributes }
      }.to change(Chat, :count).by(0)
    end

    it "renders a JSON response with the chat number" do
      post :create, params: { application_application_token: application.token, chat: valid_attributes }
      expect(response).to have_http_status(:accepted)
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end
  end

  describe "PUT #update" do
    let!(:chat) { create(:chat, application: application) }
    let(:invalid_attributes) { { number: nil } }

    context "with invalid parameters" do
      it "renders a JSON response with errors for the chat" do
        put :update, params: { application_application_token: application.token, chat_number: chat.number, chat: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe "GET #show" do
    let!(:chat) { create(:chat, application: application) }

    context "when chat exists" do
      it "returns the chat" do
        get :show, params: { application_application_token: application.token, chat_number: chat.number }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context "when chat does not exist" do
      it "returns a not found status" do
        get :show, params: { application_application_token: application.token, chat_number: 999 }
        expect(response).to have_http_status(:not_found)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end
end
